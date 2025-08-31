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
//Init params
window['parameterAppId'] 				= '1F0D7D17-CD3B-442F-8120-FA7F6B15377D';
window['parameterGetConfigRoot'] 		= 'http://www.mantinsa.com/apps/Component/Process/System/Mobile.cfc'
window['parameterIsCordovaEnabled'] 	= 0;

if (window['parameterIsCordovaEnabled'] == 1) {
	$(document).on("deviceready", function(e) {
		getSystemParameters();
		cordova.exec(null, null, "SplashScreen", "hide", []);
	});
}else{
	$(document).ready(function(e) {
		getSystemParameters();
	});
}