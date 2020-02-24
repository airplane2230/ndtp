<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="api27" class="api-help-toggle">
	<div class="menu_tab">
		<ul>
			<li class="fst active"><a href="#" onclick="tabMenu(0);">Run</a></li>
			<li><a href="#" onclick="tabMenu(1);">Code</a></li>
		</ul>
	</div>
	<div class="menu_tab00 mTs" id="panels">
		<h2>isDataExistAPI</h2>
		<p>환경 설정 data map에 key 값의 존재 유무를 판별하는 API입니다.</p>
		<table>
		<caption>Parameter</caption>
			<tr>
				<th scope="col">name</th>
				<th scope="col">type</th>
				<th scope="col">description</th>
			</tr>
			<tr>
				<td>dataKey</td>
				<td>String</td>
				<td>데이터 고유키</td>
			</tr>
		</table>
		<br>
		<table>
		<caption>Return</caption>
			<tr>
				<th scope="col">type</th>
				<th scope="col">description</th>
			</tr>
			<tr>
				<td>Boolean</td>
				<td>true: 존재, false: 없음</td>
			</tr>
		</table>
		<br>
		<h4>실행</h4>
		<div class="paramContainer">
			<label for="api27-p1">dataKey</label>
			<input type="text" data-require="true" id="api27-p1" value="sample">
		</div>
		<br> <input type="button" id="isDataExist" value="Run" class="popupBtn">
		<h4>결과</h4>
		<div id="api27-result"></div>
	</div>

	<div class="menu_tab01 mTs" id="panels" style="display: none;"></div>
</div>
<script>
	var isDataExist = function() {

		var dataKey = $('#api27-p1').val();
		var result = isDataExistAPI("projectId_" + dataKey.toString());

		document.getElementById("api27-result").innerText = result.toString();

	}
</script>