<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfparam name="attributes.appId"	default="">
<cfparam name="attributes.action"	default="../SelfService/LogonAjaxSubmit.cfm?returnValue=1&printResult=1">

<cfset rootMobileTag = getbasetagdata("CF_MOBILE")>
<cfset attributes.appId = rootMobileTag.attributes.appId>

<cfquery name="getApplication" 
	datasource="AppsSystem">		 
		SELECT  *
		FROM    #client.lanPrefix#Ref_ModuleControl	 
		WHERE	SystemModule = 'PMobile'
		AND		FunctionClass = 'PMobile'
		AND		FunctionName = '#attributes.appId#'
		AND		Operational = 1
</cfquery>

<cfoutput>
	<script>
		function _login() {
			var vResult = $.trim($('##loginResult').contents().find('body').html());
			if (vResult === '1') {
				window.location.href = '#session.root#/#getApplication.functionDirectory##getApplication.FunctionPath#?appId=#attributes.appId#&mission=#getApplication.functionCondition#';
			}else{
				$('.clsLoginLocalResult').html(vResult);
			}
		}
	</script>
</cfoutput>
	
<div class="color-line"></div>
	
<div class="login-container">
	<div class="login-container">
	    <div class="row">
	        <div class="col-md-12">
                <div class="clsLoginBrandLogo"><cfoutput><img src="#session.root#/#getApplication.functionDirectory#/Images/BrandLogo.png"></cfoutput></div>
	            <div class="text-center m-b-md">
					<cfoutput>
		                <h3>#getApplication.FunctionMemo#</h3>
		                <small>#getApplication.FunctionInfo#</small>
					</cfoutput>
	            </div>
	            <div class="hpanel">
	                <div class="panel-body">
						<cfif getApplication.recordCount eq 0>
							<div class="text-center">
								<h3><cf_tl id="You don't have a valid session on this application"></h3>
								<h3><cf_tl id="Please login again or contact your administrator"></h3>
							</div>
						<cfelse>
							<cfoutput>
		                        <form 
									action="#attributes.action#" 
									target="loginResult" 
									id="loginForm" 
									method="post"
									onsubmit="$('.clsLoginLocalResult').html('<img style=height:20px; src=#session.root#/Portal/Mobile/Images/busyW8.gif>');" >
		                            <div class="form-group">
		                                <label class="control-label" for="account"><cf_tl id="Username"></label>
										<cf_tl id="Type your username" var="lblph">
										<cf_tl id="Please enter your username" var="lbltitle">
		                                <input type="text" placeholder="#lblph#" title="#lbltitle#" required="" value="" name="account" id="account" class="form-control">
		                                <!--- <span class="help-block small">Your unique username to app</span> --->
		                            </div>
		                            <div class="form-group">
		                                <label class="control-label" for="password"><cf_tl id="Password"></label>
										<cf_tl id="Please enter your password" var="lbltitle2">
										<cf_tl id="Type your password" var="lblph2">
		                                <input type="password" title="#lbltitle2#" placeholder="#lblph2#" required="" value="" name="password" id="password" class="form-control">
		                                <!--- <span class="help-block small">Your strong password</span> --->
		                            </div>
		                            <button class="btn btn-block clsProsisDrk"><cf_tl id="Login"></button>
		                            <!--- <a class="btn btn-default btn-block" href="#">Register</a> --->
		                        </form>
							</cfoutput>
						</cfif>
	                </div>
					<div class="clsLoginResult" style="text-align:center; padding-top:8px;" id="_processAjax">
						<span class="clsLoginLocalResult" style="color:red;"></span>
						<iframe 
							name="loginResult" 
							id="loginResult" 
							frameborder="0" 
							style="display:none;" 
							onload="_login();"></iframe>
					</div>
					<div align="center">
					<cfoutput>
							<a href="#session.root#/PasswordAssist.cfm"><cf_tl id="Forgot password"></a>
					</cfoutput>
					</div>
	            </div>
	        </div>
	    </div>
	    <div class="row">
	        <div class="col-md-12 text-center clsLoginFooterInfo">
                <cfoutput><img src="#session.root#/Images/MobileApps/MobileApplicationIcon.png"></cfoutput>
	            <strong>Prosis</strong><br/>
                <span>Mobile WebApp<br/> <cfoutput>#year(now())#</cfoutput> - Promisan, b.v.</span>
	        </div>
	    </div>
	</div>
</div>