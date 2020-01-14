<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<ul class="listDrop">
	<li class="on">
		<p>방사형 가시성 분석</p>
		<div class="listContents" id="analysisRadialLineOfSight">
			<ul class="analysisGroup">
				<li>
					<label for="">분석 자료</label>
					<select class="dataType">
						<option value="DEM" selected="">DEM (DEM)</option>
						<option value="DSM">DSM (DSM)</option>
					</select>
				</li>
				<li>
					<label for="">관찰 높이 (m)</label>
					<input class="observerOffset" type="text" placeholder="" value="1.7">
				</li>
				<li>
					<label for="">반경 (m)</label>
					<input class="radius" type="text" placeholder="" value="100">
				</li>
				<li>
					<label for="">선분 수 (number)</label>
					<input class="sides" type="text" placeholder="" value="90">
				</li>
				<li>
					<label for="">관찰자 위치</label>
					<input type="text" placeholder="" class="withBtn observerPointMGRS">
					<input type="hidden" class="observerPoint">
					<button type="button" class="btnText drawObserverPoint" data-draw-type="POINT">위치지정</button>
				</li>
				<li class="btns">
					<button type="button" class="btnTextF execute" title="방사형 가시성 분석">분석</button>
					<button type="button" class="btnText reset" title="취소">취소</button>
				</li>
			</ul>
		</div>
	</li>
	<li>
		<p>가시선 분석</p>
		<div class="listContents" id="analysisLinearLineOfSight">
			<ul class="analysisGroup">
				<li>
					<label for="">분석 자료</label>
					<select class="dataType">
						<option value="DEM" selected="">DEM (DEM)</option>
						<option value="DSM">DSM (DSM)</option>
					</select>
				</li>
				<li>
					<label for="">관찰 높이 (m)</label>
					<input class="observerOffset" type="text" placeholder="" value="1.7">
				</li>
				<li>
					<label for="">관찰 위치</label>
					<input type="text" placeholder="" class="withBtn observerPointMGRS">
					<input type="hidden" class="observerPoint">
					<button type="button" class="btnText drawObserverPoint" data-draw-type="POINT">위치지정</button>
				</li>
				<li>
					<label for="">대상 위치</label>
					<input type="text" placeholder="" class="withBtn targetPointMGRS">
					<input type="hidden" class="targetPoint">
					<button type="button" class="btnText drawTargetPoint" data-draw-type="POINT">위치지정</button>
				</li>
				<li class="btns">
					<button type="button" class="btnTextF execute" title="가시선 분석">분석</button>
					<button type="button" class="btnText reset" title="취소">취소</button>
				</li>
			</ul>
		</div>
	</li>
	<li>
		<p>지형 단면 분석</p>
		<div class="listContents" id="analysisRasterProfile">
			<ul class="analysisGroup">
				<li>
					<label for="">분석 자료</label>
					<select class="dataType">
						<option value="DEM" selected="">DEM (DEM)</option>
						<option value="DSM">DSM (DSM)</option>
					</select>
				</li>
				<li>
					<label for="">간격 (number)</label>
					<input class="interval" type="text" placeholder="" value="20">
				</li>
				<li>
					<label for="">사용자 입력 선분</label>
					<button type="button" class="btnText drawUserLine" data-draw-type="LINE">위치지정</button>
					<input type="hidden" class="userLine">
					<div class="coordsText"></div>
				</li>
				<li class="btns">
					<button type="button" class="btnTextF execute" title="지형 단면 분석">분석</button>
					<button type="button" class="btnText reset" title="취소">취소</button>
				</li>

				<li class="profileInfo">
					<div class="legend"></div>
				</li>
			</ul>
		</div>
	</li>
	<li>
		<p>지형 최고/최저 점</p>
		<div class="listContents" id="analysisRasterHighLowPoints">
			<ul class="analysisGroup">
				<li>
					<label for="">분석 자료</label>
					<select class="dataType">
						<option value="DEM" selected="">DEM (DEM)</option>
						<option value="DSM">DSM (DSM)</option>
					</select>
				</li>
				<li>
					<label for="">면적 타입</label>
					<select class="areaType">
						<option value="useArea">사용자 영역</option>
						<option value="extent">현재 지도 영역</option>
					</select>
				</li>
				<li class="wrapCropShape">
					<label for=""></label>
					<input type="hidden" class="cropShape">
					<button type="button" class="btnText drawCropShape" data-draw-type="POLYGON">영역 그리기</button>
				</li>
				<li>
					<label for="">최고/최저</label>
					<select class="valueType">
						<option value="High">최고</option>
						<option value="Low">최저</option>
					</select>
				</li>
				<li class="btns">
					<input type="hidden" class="wcsExtent">
					<button type="button" class="btnTextF execute" title="지형 최고/최저 점 분석">분석</button>
					<button type="button" class="btnText reset" title="취소">취소</button>
				</li>
			</ul>
		</div>
	</li>
	<li>
		<p>위험 돔 분석</p>
		<div class="listContents" id="analysisRangeDome">
			<ul class="analysisGroup">
				<li>
					<label for="">반경 (m)</label>
					<input class="radius" type="text" placeholder="" value="1000">
				</li>
				<li>
					<label for="">관찰 위치</label>
					<input type="text" placeholder="" class="withBtn observerPointMGRS">
					<input type="hidden" class="observerPoint">
					<button type="button" class="btnText drawObserverPoint" data-draw-type="POINT">위치지정</button>
				</li>
				<li class="btns">
					<button type="button" class="btnTextF execute" title="위험 돔 분석 실행">분석</button>
					<button type="button" class="btnText reset" title="취소">취소</button>
				</li>
			</ul>
		</div>
	</li>
</ul>