package ndtp.config;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;
import ndtp.domain.CacheManager;
import ndtp.domain.CacheName;
import ndtp.domain.CacheParams;
import ndtp.domain.CacheType;
import ndtp.domain.DataGroup;
import ndtp.domain.DataInfoSimple;
import ndtp.domain.Menu;
import ndtp.domain.MenuTarget;
import ndtp.domain.RoleTarget;
import ndtp.domain.UserGroup;
import ndtp.domain.UserGroupMenu;
import ndtp.domain.UserGroupRole;
import ndtp.service.DataGroupService;
import ndtp.service.DataService;
import ndtp.service.MenuService;
import ndtp.service.UserGroupService;

@Slf4j
@Component
public class CacheConfig {
	
	@Autowired
	private DataService dataService;
	@Autowired
	private DataGroupService dataGroupService;
	@Autowired
	private MenuService menuService;
	@Autowired
    private UserGroupService userGroupService;

    @PostConstruct
    public void init() {
    	log.info("*************************************************");
        log.info("************ User Cache Init Start *************");
        log.info("*************************************************");

        CacheParams cacheParams = new CacheParams();
		cacheParams.setCacheType(CacheType.SELF);
        
        // 사용자 그룹별 메뉴, Role
        userGroupMenuAndRole(cacheParams);
        // Smart Tiling 데이터 그룹별 데이터 목록
//        smartTilingData(cacheParams);
        
        log.info("*************************************************");
        log.info("************* User Cache Init End **************");
        log.info("*************************************************");
    }
    
    public void loadCache(CacheParams cacheParams) {
		CacheName cacheName = cacheParams.getCacheName();
		
		if(cacheName == CacheName.POLICY) policy(cacheParams);
		else if(cacheName == CacheName.MENU) menu(cacheParams);
		else if(cacheName == CacheName.USER_GROUP) userGroupMenuAndRole(cacheParams);
		else if(cacheName == CacheName.SMART_TILING_DATA) smartTilingData(cacheParams);
	}
    
    /**
     * policy
     * @param cacheParams
     */
    private void policy(CacheParams cacheParams) {
    	CacheType cacheType = cacheParams.getCacheType();
    	if(cacheType == CacheType.BROADCAST) {
    		callRemoteCache(cacheParams);
    	}
    }
    
    /**
     * menu
     * @param cacheParams
     */
    private void menu(CacheParams cacheParams) {
    	CacheType cacheType = cacheParams.getCacheType();
    	if(cacheType == CacheType.BROADCAST) {
    		callRemoteCache(cacheParams);
    	}
    }

    /**
     * 사용자 그룹, 메뉴, Role
     */
    private void userGroupMenuAndRole(CacheParams cacheParams) {
    	Map<Integer, Menu> menuMap = new HashMap<>();
		Map<String, Integer> menuUrlMap = new HashMap<>();
		Menu userMenu = new Menu();
		userMenu.setDefaultYn(null);
		userMenu.setMenuTarget(MenuTarget.USER.getValue());
		
		List<Menu> menuList = menuService.getListMenu(userMenu);
		for(Menu menu : menuList) {
			menuMap.put(menu.getMenuId(), menu);
			menuUrlMap.put(menu.getUrl(), menu.getMenuId());
		}
    	
    	UserGroup inputUserGroup = new UserGroup();
    	inputUserGroup.setAvailable(Boolean.TRUE);
    	List<UserGroup> userGroupList = userGroupService.getListUserGroup(inputUserGroup);
    	
    	Map<Integer, List<UserGroupMenu>> userGroupMenuMap = new HashMap<>();
    	Map<Integer, List<String>> userGroupRoleMap = new HashMap<>();
    	
    	UserGroupMenu userGroupMenu = new UserGroupMenu();
    	userGroupMenu.setMenuTarget(MenuTarget.USER.getValue());
    	
    	UserGroupRole userGroupRole = new UserGroupRole();
    	userGroupRole.setRoleTarget(RoleTarget.USER.getValue());
    	for(UserGroup userGroup : userGroupList) {
    		Integer userGroupId = userGroup.getUserGroupId();
    		
    		userGroupMenu.setUserGroupId(userGroupId);
    		List<UserGroupMenu> userGroupMenuList = userGroupService.getListUserGroupMenu(userGroupMenu);
    		userGroupMenuMap.put(userGroupId, userGroupMenuList);
    		
    		userGroupRole.setUserGroupId(userGroupId);
    		List<String> userGroupRoleKeyList = userGroupService.getListUserGroupRoleKey(userGroupRole);
    		userGroupRoleMap.put(userGroupId, userGroupRoleKeyList);
    	}
    	
    	CacheManager.setMenuMap(menuMap);
		CacheManager.setMenuUrlMap(menuUrlMap);
    	CacheManager.setUserGroupMenuMap(userGroupMenuMap);
    	CacheManager.setUserGroupRoleMap(userGroupRoleMap);
    	
//    	CacheType cacheType = cacheParams.getCacheType();
		
    }
    
    /**
     * Smart Tiling 데이터
     * @param cacheParams
     */
    private void smartTilingData(CacheParams cacheParams) {
    	Map<Integer, List<DataInfoSimple>> smartTilingDataMap = new HashMap<>();
    	
    	DataGroup smartTilingDataGroup = DataGroup.builder().tiling(true).build();
    	List<DataGroup> smartTilingDataGroupList = dataGroupService.getAllListDataGroup(smartTilingDataGroup);
    	for(DataGroup dataGroup : smartTilingDataGroupList) {
    		List<DataInfoSimple> dataList = dataService.getListAllDataByDataGroupId(dataGroup.getDataGroupId());
    		smartTilingDataMap.put(dataGroup.getDataGroupId(), dataList);
    	}
    	
    	CacheManager.setSmartTilingDataMap(smartTilingDataMap);
    	
//    	CacheType cacheType = cacheParams.getCacheType();
//    	if(cacheType == CacheType.BROADCAST) {
//    		callRemoteCache(cacheParams);
//    	}
    }
    
    /**
	 * Remote Cache 갱신 요청
	 * @param cacheName
	 */
	private void callRemoteCache(CacheParams cacheParams) {
		log.info("@@@@@@@@@@@@@@@@@@@@@@@@@@ callRemoteCache start! ");
	}
}
