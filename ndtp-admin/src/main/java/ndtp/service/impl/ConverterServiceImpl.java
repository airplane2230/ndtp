package ndtp.service.impl;

import java.io.File;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import ndtp.config.PropertiesConfig;
import ndtp.domain.ConverterJob;
import ndtp.domain.ConverterJobFile;
import ndtp.domain.ConverterJobStatus;
import ndtp.domain.DataGroup;
import ndtp.domain.DataInfo;
import ndtp.domain.QueueMessage;
import ndtp.domain.UploadData;
import ndtp.domain.UploadDataFile;
import ndtp.persistence.ConverterMapper;
import ndtp.service.AMQPPublishService;
import ndtp.service.ConverterService;
import ndtp.service.DataGroupService;
import ndtp.service.DataService;
import ndtp.service.GeoPolicyService;
import ndtp.service.UploadDataService;

/**
 * converter manager
 * @author jeongdae
 *
 */
@Slf4j
@Service
public class ConverterServiceImpl implements ConverterService {

	@Autowired
	private AMQPPublishService aMQPPublishService;
	
	@Autowired
	private DataService dataService;
	
	@Autowired
	private DataGroupService dataGroupService;
	@Autowired
	private GeoPolicyService geoPolicyService;
	@Autowired
	private PropertiesConfig propertiesConfig;
	@Autowired
	private UploadDataService uploadDataService;
	
	@Autowired
	private ConverterMapper converterMapper;
	
	/**
	 * converter 변환
	 * @param converterJob
	 * @return
	 */
	@Transactional
	public int insertConverter(ConverterJob converterJob) {
		
		String dataGroupRootPath = geoPolicyService.getGeoPolicy().getDataServicePath() + File.separator;
		String title = converterJob.getTitle();
		String converterTemplate = converterJob.getConverterTemplate();
		String userId = converterJob.getUserId();
		
		String[] uploadDataIds = converterJob.getConverterCheckIds().split(",");
		for(String uploadDataId : uploadDataIds) {
			// 1. job을 하나씩 등록
			ConverterJob inConverterJob = new ConverterJob();
			inConverterJob.setUploadDataId(Long.valueOf(uploadDataId));
			inConverterJob.setUserId(userId);
			inConverterJob.setTitle(title);
			inConverterJob.setConverterTemplate(converterTemplate);
			
			UploadData uploadData = new UploadData();
			uploadData.setUserId(userId);
			uploadData.setUploadDataId(Long.valueOf(uploadDataId));
			uploadData.setConverterTarget(true);
			List<UploadDataFile> uploadDataFileList = uploadDataService.getListUploadDataFile(uploadData);
			
			inConverterJob.setFileCount(uploadDataFileList.size());
			converterMapper.insertConverterJob(inConverterJob);
			
			Long converterJobId = inConverterJob.getConverterJobId();
			for(UploadDataFile uploadDataFile : uploadDataFileList) {
				ConverterJobFile converterJobFile = new ConverterJobFile();
				converterJobFile.setConverterJobId(converterJobId);
				converterJobFile.setUploadDataId(Long.valueOf(uploadDataId));
				converterJobFile.setUploadDataFileId(uploadDataFile.getUploadDataFileId());
				converterJobFile.setDataGroupId(uploadDataFile.getDataGroupId());
				converterJobFile.setUserId(userId);
				
				// 2. job file을 하나씩 등록
				converterMapper.insertConverterJobFile(converterJobFile);
				
				// 3. 데이터를 등록
				insertData(userId, uploadDataFile);
				
				// queue 를 실행
				executeConverter(dataGroupRootPath, converterJobFile, uploadDataFile);
			}
			
			// TODO 이걸 왜 추가 했지? 삭제해야 할듯
			DataGroup dataGroup = new DataGroup();
			//project.setProject_id(project_id);
			dataGroupService.updateDataGroup(dataGroup);
		}
		
		return uploadDataIds.length;
	}
	
	private void executeConverter(String dataGroupRootPath, ConverterJobFile converterJobFile, UploadDataFile uploadDataFile) {
		DataGroup dataGroup = new DataGroup();
		dataGroup.setDataGroupId(uploadDataFile.getDataGroupId());
		dataGroup = dataGroupService.getDataGroup(dataGroup);
		
		QueueMessage queueMessage = new QueueMessage();
		queueMessage.setConverterJobId(converterJobFile.getConverterJobId());
		queueMessage.setInputFolder(uploadDataFile.getFilePath());
		queueMessage.setOutputFolder(dataGroupRootPath + dataGroup.getDataGroupPath());
		queueMessage.setMeshType("0");
		queueMessage.setLogPath(dataGroupRootPath + dataGroup.getDataGroupPath() + "logTest.txt");
		queueMessage.setIndexing("y");
		
		// TODO
		// 조금 미묘하다. transaction 처리를 할지, 관리자 UI 재 실행을 위해서는 여기가 맞는거 같기도 하고....
		// 별도 기능으로 분리해야 하나?
		try {
			aMQPPublishService.send(queueMessage);
		} catch(Exception ex) {
			ConverterJob converterJob = new ConverterJob();
			converterJob.setConverterJobId(converterJobFile.getConverterJobId());
			converterJob.setStatus(ConverterJobStatus.WAITING.name());
			converterJob.setErrorCode(ex.getMessage());
			converterMapper.updateConverterJob(converterJob);
			
			ex.printStackTrace();
		}
	}
	
	private void insertData(String userId, UploadDataFile uploadDataFile) {
		int order = 1;
		// TODO nodeType 도 입력해야 함
		String attributes = "{\"isPhysical\": true}";
		
		DataInfo dataInfo = new DataInfo();
		dataInfo.setDataGroupId(uploadDataFile.getDataGroupId());
		dataInfo.setSharing(uploadDataFile.getSharing());
		dataInfo.setDataKey(uploadDataFile.getFileRealName().substring(0, uploadDataFile.getFileRealName().lastIndexOf(".")));
		dataInfo.setDataName(uploadDataFile.getFileName().substring(0, uploadDataFile.getFileName().lastIndexOf(".")));
		dataInfo.setUserId(userId);
		dataInfo.setLatitude(uploadDataFile.getLatitude());
		dataInfo.setLongitude(uploadDataFile.getLongitude());
		dataInfo.setAltitude(uploadDataFile.getAltitude());
		dataInfo.setLocation("POINT(" + dataInfo.getLongitude() + " " + dataInfo.getLatitude() + ")");
		dataInfo.setAttributes(attributes);
		dataService.insertData(dataInfo);
	}
}