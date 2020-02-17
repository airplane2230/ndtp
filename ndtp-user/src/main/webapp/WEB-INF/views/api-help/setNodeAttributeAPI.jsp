<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div id="api43" class="apihelptoggle" style="display: none;">
	<div class="menu_tab">
		<ul>
			<li class="fst active"><a href="#;" onclick="tab_menu(0);">Run</a></li>
			<li><a href="#;" onclick="tab_menu(1);">Code</a></li>
		</ul>
	</div>
	<div class="menu_tab00 mTs" id="panels">
	<h2>setNodeAttributeAPI</h2>
	
	<p>데이터의 속성을 설정하는 API입니다.</p>
		<h4>파라미터</h4>
		<table>
		<tr><th>name</th><th>type</th><th>description</th></tr>
		<tr><td>managerFactoryInstance</td><td>ManagerFactory</td><td>mago3D 시작 부분</td></tr>
		<tr><td>projectId</td><td>String</td><td>프로젝트 아이디</td></tr>
		<tr><td>dataKey</td><td>String</td><td>데이터 고유키</td></tr>
		<tr><td>option</td><td>Object</td><td>데이터 속성</td></tr>
		</table></br>
		<h4>실행</h4>
	<div class="paramContainer">
		<p>projectId :</p>
		<input type="text" id="api43-p1" value="sample"></br>
		<p>dataKey :</p>
		<input type="text" id="api43-p2" value="SOCIALROOM"></br>
		<p>isVisible :</p>
		<input type="text" id="api43-p3" value="true"></div></br> <input
			type="button" value="Run" class="popupBtn" onclick="setNodeAttribute()">
	</div>
	<div class="menu_tab01 mTs" id="panels" style="display: none;">
		</div>
</div>
<script>
	var setNodeAttribute = function() {

		var p1 = $('#api43-p1').val();
		var p2 = $('#api43-p2').val();
		var p3 = $('#api43-p3').val();

		var isFalseBoolean = (p3 === 'true');

		var optionObject = {
			isVisible : isFalseBoolean
		}

		var r1 = setNodeAttributeAPI(MAGO3D_INSTANCE2, p1, p2, optionObject);
	}
</script>