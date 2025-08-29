/*
 * Copyright © 2025 Promisan B.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
function _login(id) {
	var vResult = $.trim($('#loginResult').contents().find('body').html());
	if (vResult === '1') {
		ptoken.navigate('HTML5/OnLogin.cfm?id='+id,'_processAjax');
	}else{
		$('.clsLoginLocalResult').html(vResult);
	}
}

function _loginWait(imgUrl) {
	$('.clsLoginLocalResult').html('<img src="' + decodeURIComponent(imgUrl) + '">');
}

function _logout(id) {
	ptoken.navigate('HTML5/BeforeLogout.cfm?id='+id,'_processAjax');
}

function _changeMission(root, mis, id, reload) {
	ptoken.navigate(decodeURIComponent(root)+'/Portal/SelfService/HTML5/ChangeMission.cfm?mission='+mis+'&reload='+reload+'&id='+id, '_processAjax');
}

function _changeLanguage(root, id, lang) {
	ptoken.navigate(decodeURIComponent(root)+'/Tools/Language/Switch.cfm?webapp='+id+'&show=0&ID='+lang+'&menu=yes','_processAjax');
}

function _logActivity(root, id, mis) {
	ptoken.navigate(decodeURIComponent(root)+'/Tools/SubmenuLog.cfm?systemfunctionid='+id+'&mission='+mis,'_processAjax')
}

function validateKeyPress(event) {
	if((event.shiftKey || event.key == 'Shift' || event.ctrlKey || event.altKey) && event.keyCode == 13) {
		event.preventDefault();
		return false;
	}
	return true;
}

function validateSpecialKeyPress(event) {
	if(event.shiftKey || event.key == 'Shift' || event.ctrlKey || event.altKey) {
		event.preventDefault();
		return false;
	}
	return true;
}