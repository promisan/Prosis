<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="Form.Operational"        default="0">
<cfparam name="Form.Code"               default="0">
<cfparam name="Form.Description"        default="">
<cfparam name="Form.Mission"            default="">
<cfparam name="Form.EntryMode"          default="Manual">
<cfparam name="Form.topicclassValues"   default="">

<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="#url.alias#" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE Ref_Funding
		  SET    fundingType = '#Form.fundingType#',
<!---		  		 period = '#Form.period#',--->
				 fund = '#Form.fund#',
				 orgUnitCode = '#Form.orgUnitCode#',
				 projectCode = '#Form.projectCode#',
				 programCode = '#Form.programCode#',
				 objectCode = '#Form.objectCode#',
				 CBGrant = '#Form.CBGrant#',
				 glAccount = '#Form.glAccount#',				 
				 reference = '#Form.reference#',
				 officerUserId = '#SESSION.acc#',
				 officerLastName = '#SESSION.last#',
				 officerFirstName = '#SESSION.first#',
				 created = getDate()
		  WHERE  FundingId = '#URL.ID2#'
	</cfquery>
				
<cfelse>
			
	<cfquery name="Exist" 
	    datasource="#url.alias#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT 	 *
		FROM   	 Ref_Funding
		WHERE  	 fundingType = '#Form.fundingType#'
<!---		AND		 period = '#Form.period#'--->
		AND		 fund = '#Form.fund#'
		AND		 orgUnitCode = '#Form.orgUnitCode#'
		AND		 projectCode = '#Form.projectCode#'
		AND		 programCode = '#Form.programCode#'
		AND		 objectCode = '#Form.objectCode#'
		AND		 glAccount = '#Form.glAccount#'
		AND		 CBGrant = '#Form.CBGrant#'
		
	</cfquery>
		
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="#url.alias#" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO [WorkOrder].[dbo].[Ref_Funding]
			           ([FundingId]
			           ,[FundingType]
<!---			           ,[Period]--->
			           ,[Fund]
			           ,[OrgUnitCode]
			           ,[ProjectCode]
			           ,[ProgramCode]
			           ,[ObjectCode]
			           ,[CBGrant]					   
			           ,[GLAccount]
			           ,[Reference]
			           ,[OfficerUserId]
			           ,[OfficerLastName]
			           ,[OfficerFirstName]
			           ,[Created])
			     VALUES
			           (newId()
			           ,'#Form.fundingType#'
<!---			           ,'#Form.period#'--->
			           ,'#Form.fund#'
			           ,'#Form.orgUnitCode#'
			           ,'#Form.projectCode#'
			           ,'#Form.programCode#'
			           ,'#Form.objectCode#'
					   ,'#Form.CBGrant#'
			           ,'#Form.glAccount#'
			           ,'#Form.reference#'
			           ,'#SESSION.acc#'
			           ,'#SESSION.last#'
			           ,'#SESSION.first#'
			           ,getDate())

			</cfquery>										 
			
	<cfelse>
			
		<script>
			<cfoutput>
				alert("Sorry, this combination of funding type,  fund, orgUnit, project, program, object and account already exists")
			</cfoutput>
		</script>
				
	</cfif>		
		   	
</cfif>

<cfset url.id2 = "">
<cfinclude template="RecordListingDetail.cfm">
