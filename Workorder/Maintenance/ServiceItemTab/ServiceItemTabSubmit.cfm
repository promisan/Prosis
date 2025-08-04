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

<cfparam name="Form.CustomDialog" default="">

<cfquery name="Verify" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">		
	SELECT 	*
	FROM   	ServiceItemTab
	WHERE 	Code = '#Form.code#'
	AND 	Mission = '#Form.mission#'
	AND		TabName = '#Form.tabName#'
</cfquery>

<cfif ParameterExists(Form.Save) and ParameterExists(Form.validateIcon) and ParameterExists(Form.validateTemplate)>
	
	<cfif Verify.recordcount gt 0>
	
		<script language="JavaScript">alert("A record with this mission, serviceItem and name has been registered already!")</script>  
	
	<cfelse>
		<cfset errorMessage = "">

		<cfif trim(Form.tabIcon) neq "" and form.validateIcon eq "0">
			<cfset errorMessage = errorMessage & "Icon path does not exist.\n">
		</cfif>
		
		<cfif trim(Form.tabTemplate) neq "" and form.validateTemplate eq "0">
			<cfset errorMessage = errorMessage & "Template path does not exist.\n">
		</cfif>
		
		<cfif errorMessage neq "">
			
			<cfoutput>
				<script language="JavaScript">alert("#errorMessage#")</script>
			</cfoutput>
		
		<cfelse>
		
		<cfquery name="Insert" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		INSERT INTO ServiceItemTab
	           (Mission,
	           Code,
	           TabName,
	           <cfif trim(Form.tabOrder) neq "">TabOrder,</cfif>
	           <cfif trim(Form.tabIcon) neq "">TabIcon,</cfif>
	           <cfif trim(Form.tabTemplate) neq "">TabTemplate,</cfif>
	           AccessLevelRead,
	           AccessLevelEdit,
	           ModeOpen,
	           Operational)			  
	     VALUES
	           ('#Form.mission#',
	           '#Form.code#',
	           '#Form.tabName#',
	           <cfif trim(Form.tabOrder) neq "">#Form.tabOrder#,</cfif>
	           <cfif trim(Form.tabIcon) neq "">'#Form.tabIcon#',</cfif>
	           <cfif trim(Form.tabTemplate) neq "">'#Form.tabTemplate#',</cfif>
	           '#Form.AccessLevelRead#',
	           '#Form.AccessLevelEdit#',
	           '#Form.modeOpen#',
	           #Form.operational#)
			   
		</cfquery>
		
		<cfoutput>
			<script language="JavaScript">   
			 	parent.parent.showitemtabrefresh('#Form.code#')
				parent.parent.ColdFusion.Window.destroy('mydialog',true)	        
			</script>
	    </cfoutput>
		
		
		</cfif>
	
	</cfif>		
	
</cfif>

<cfif ParameterExists(Form.Update) and ParameterExists(Form.validateIcon) and ParameterExists(Form.validateTemplate)>	
	
	<cfset isUpdatable = 0>
		
	<cfif Verify.recordcount eq 0>
		<cfset isUpdatable = 1>
	<cfelse>
		<cfif trim(#form.mission#) eq trim(#form.missionOld#) and trim(#form.tabName#) eq trim(#form.tabNameOld#) >		
			<cfset isUpdatable = 1>	
		</cfif>
	</cfif>			
	
	<cfif isUpdatable eq 1>
		<cfset errorMessage = "">

		<cfif trim(Form.tabIcon) neq "" and form.validateIcon eq "0">
			<cfset errorMessage = errorMessage & "Icon path does not exist.\n">
		</cfif>
		
		<cfif trim(Form.tabTemplate) neq "" and form.validateTemplate eq "0">
			<cfset errorMessage = errorMessage & "Template path does not exist.\n">
		</cfif>
		
		<cfif errorMessage neq "">
			
			<cfoutput>
				<script language="JavaScript">alert('#errorMessage#')</script>
			</cfoutput>
		
		<cfelse>
	
		<cfquery name="Update" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE ServiceItemTab
		SET 
			  mission = '#Form.mission#',
	          tabName = '#Form.tabName#',
	          tabOrder = <cfif trim(Form.tabOrder) eq "">null<cfelse>#Form.tabOrder#</cfif>,
	          tabIcon = <cfif trim(Form.tabIcon) eq "">null<cfelse>'#Form.tabIcon#'</cfif>,
	          tabTemplate = <cfif trim(Form.tabTemplate) eq "">null<cfelse>'#Form.tabTemplate#'</cfif>,
	          AccessLevelRead = '#Form.AccessLevelRead#',
	          AccessLevelEdit = '#Form.AccessLevelEdit#',
	          modeOpen = '#Form.modeOpen#',
	          operational = #Form.operational#
		WHERE 	mission = '#Form.missionOld#'
		AND 	code = '#Form.code#'
		AND		tabName = '#Form.tabNameOld#'
		</cfquery>	
		
		<cfoutput>
			<script language="JavaScript">   
			 	parent.parent.showitemtabrefresh('#Form.code#')
				parent.parent.ProsisUI.closeWindow('mydialog',true)	        
			</script>
		</cfoutput>
		
		</cfif>
	
	<cfelse>
	
		<script language="JavaScript">alert("A record with this mission, serviceItem and name has been registered already!")</script>  	
	
	</cfif>

</cfif>	

<cfif ParameterExists(Form.Delete)>			

	<cfquery name="Delete" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM ServiceItemTab
		WHERE 	mission = '#Form.missionOld#'
		AND 	code = '#Form.code#'
		AND		tabName = '#Form.tabNameOld#'
	</cfquery>
	
	<cfoutput>
	<script language="JavaScript">   
	 	parent.parent.showitemtabrefresh('#Form.code#')
		parent.parent.ProsisUI.closeWindow('mydialog',true)		        
	</script>
	</cfoutput>
	
</cfif>	 