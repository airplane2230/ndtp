<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<%@ include file="/WEB-INF/views/common/config.jsp" %>

<!DOCTYPE html>
<html lang="${accessibility}">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width">
	<title>시민참여 목록 | NDTP</title>
	<link rel="stylesheet" href="/css/${lang}/font/font.css" />
	<link rel="stylesheet" href="/images/${lang}/icon/glyph/glyphicon.css" />
	<link rel="stylesheet" href="/externlib/normalize/normalize.min.css" />
	<link rel="stylesheet" href="/externlib/jquery-ui-1.12.1/jquery-ui.min.css" />
    <link rel="stylesheet" href="/css/${lang}/admin-style.css" />
</head>
<body>
	<%@ include file="/WEB-INF/views/layouts/header.jsp" %>
	<%@ include file="/WEB-INF/views/layouts/menu.jsp" %>
	<div class="site-body">
		<div class="container">
			<div class="site-content">
				<%@ include file="/WEB-INF/views/layouts/sub_menu.jsp" %>
				<div class="page-area">
					<%@ include file="/WEB-INF/views/layouts/page_header.jsp" %>
					<div class="page-content">
						<div class="filters">
							<form:form id="searchForm" modelAttribute="civilVoice" method="get" action="/civil-voice/list" onsubmit="return searchCheck();">
								<div class="input-group row">
									<div class="input-set">
										<label for="searchWord"><spring:message code='search.word'/></label>
										<select id="searchWord" name="searchWord" class="select" style="height: 30px;">
											<option value=""><spring:message code='select'/></option>
						          			<option value="title">제목명</option>
						          			<option value="user_id">작성자</option>
										</select>
										<form:select path="searchOption" class="select" style="height: 30px;">
											<form:option value="0"><spring:message code='search.same'/></form:option>
											<form:option value="1"><spring:message code='search.include'/></form:option>
										</form:select>
										<form:input path="searchValue" type="search" cssClass="m" cssStyle="float: right;" />
									</div>
									<div class="input-set">
										<label for="startDate"><spring:message code='search.date'/></label>
										<input type="text" class="s date" id="startDate" name="startDate" autocomplete="off" />
										<span class="delimeter tilde">~</span>
										<input type="text" class="s date" id="endDate" name="endDate" autocomplete="off" />
									</div>
									<div class="input-set">
										<label for="orderWord"><spring:message code='search.order'/></label>
										<select id="orderWord" name="orderWord" class="select" style="height: 30px;">
											<option value=""> <spring:message code='search.basic'/> </option>
											<option value="title">제목명</option>
						          			<option value="user_id">작성자</option>
											<option value="insert_date"> <spring:message code='search.insert.date'/> </option>
										</select>
										<select id="orderValue" name="orderValue" class="select" style="height: 30px;">
					                		<option value=""> <spring:message code='search.basic'/> </option>
						                	<option value="ASC"> <spring:message code='search.ascending'/> </option>
											<option value="DESC"> <spring:message code='search.descending.order'/> </option>
										</select>
										<form:select path="listCounter" class="select" style="height: 30px;">
					                		<form:option value="10"><spring:message code='search.ten.count'/></form:option>
						                	<form:option value="50"><spring:message code='search.fifty.count'/></form:option>
											<form:option value="100"><spring:message code='search.hundred.count'/></form:option>
										</form:select>
									</div>
									<div class="input-set">
										<input type="submit" value="<spring:message code='search'/>" />
									</div>
								</div>
							</form:form>
						</div>
						<div class="list">
							<form:form id="listForm" modelAttribute="civilVoice" method="post">
								<div class="list-header row">
									<div class="list-desc u-pull-left">
										<spring:message code='all.d'/> <em><fmt:formatNumber value="${pagination.totalCount}" type="number"/></em><spring:message code='search.what.count'/>
										<fmt:formatNumber value="${pagination.pageNo}" type="number"/> / <fmt:formatNumber value="${pagination.lastPage }" type="number"/> <spring:message code='search.page'/>
									</div>
								</div>
								<table class="list-table scope-col">
									<col class="col-number" />
									<col class="col-type" />
									<col class="col-name" />
									<col class="col-name" />
									<col class="col-type" />
									<col class="col-functions" />
									<col class="col-functions" />
									<thead>
										<tr>
											<th scope="col" class="col-number"><spring:message code='number'/></th>
						                    <th scope="col">동의</th>
						                    <th scope="col" style="width:600px">제목</th>
						                    <th scope="col">조회수</th>
						                    <th scope="col">편집</th>
						                    <th scope="col">작성자</th>
						                    <th scope="col">등록일</th>
										</tr>
									</thead>
									<tbody>
	<c:if test="${empty civilVoiceList}">
										<tr>
											<td colspan="6" class="col-none">시민참여 목록이 존재하지 않습니다.</td>
										</tr>
	</c:if>
	<c:if test="${!empty civilVoiceList}">
		<c:forEach var="civilVoice" items="${civilVoiceList}" varStatus="status">

										<tr>
											<td class="col-number">${pagination.rowNumber - status.index}</td>
											<td class="col-type" style="color: #573592; font-weight: bold;"><span class="likes-icon" style="float: left;">icon</span> ${civilVoice.commentCount}</td>
											<td class="col-name">
												<a href="/civil-voice/detail?civilVoiceId=${civilVoice.civilVoiceId}&amp;pageNo=${pagination.pageNo }${pagination.searchParameters}" class="linkButton">${civilVoice.title}</a>
											</td>
											<td class="col-name">${civilVoice.viewCount}</td>
											<td class="col-type">
												<a href="/civil-voice/modify?civilVoiceId=${civilVoice.civilVoiceId}" onclick="" class="linkButton">수정</a>&nbsp;&nbsp;
												<a href="/civil-voice/delete?civilVoiceId=${civilVoice.civilVoiceId}" onclick="return deleteWarning();" class="linkButton"><spring:message code='delete'/></a>
											</td>
											<td class="col-type">${civilVoice.userId}</td>
											<td class="col-functions">
												<fmt:parseDate value="${civilVoice.insertDate}" var="viewInsertDate" pattern="yyyy-MM-dd HH:mm:ss"/>
												<fmt:formatDate value="${viewInsertDate}" pattern="yyyy-MM-dd HH:mm"/>
											</td>
										</tr>
		</c:forEach>
	</c:if>
									</tbody>
								</table>
							</form:form>
						</div>
						<%@ include file="/WEB-INF/views/common/pagination.jsp" %>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="/WEB-INF/views/layouts/footer.jsp" %>

<script type="text/javascript" src="/externlib/jquery-3.3.1/jquery.min.js"></script>
<script type="text/javascript" src="/externlib/jquery-ui-1.12.1/jquery-ui.min.js"></script>
<script type="text/javascript" src="/js/${lang}/common.js"></script>
<script type="text/javascript" src="/js/${lang}/message.js"></script>
<script type="text/javascript" src="/js/navigation.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		initDatePicker();

		$("#searchWord").val("${civilVoice.searchWord}");
		$("#searchValue").val("${civilVoice.searchValue}");
		$("#orderWord").val("${civilVoice.orderWord}");
		$("#orderValue").val("${civilVoice.orderValue}");

		initCalendar(new Array("startDate", "endDate"), new Array("${civilVoice.startDate}", "${civilVoice.endDate}"));
	});

	function searchCheck() {
		if($("#searchOption").val() == "1") {
			if(confirm(JS_MESSAGE["search.option.warning"])) {
				// go
			} else {
				return false;
			}
		}

		var startDate = $("#startDate").val();
		var endDate = $("#endDate").val();
		if(startDate != null && startDate != "" && endDate != null && endDate != "") {
			if(parseInt(startDate) > parseInt(endDate)) {
				alert(JS_MESSAGE["search.date.warning"]);
				$("#startDate").focus();
				return false;
			}
		}
		return true;
	}
</script>
</body>
</html>
