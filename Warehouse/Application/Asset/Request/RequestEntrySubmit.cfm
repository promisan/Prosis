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

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset DTE = #dateValue#>

<cfparam name="form.assetId" default="">

<cfif Form.AssetId eq "">

	<cf_tl id = "No items to partially fullfill this requirement have been selected." class="message" var = "1">
	<cf_alert message="#lt_text#">
    <cfabort>
	
</cfif>

<cfquery name="Parameter" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM   Parameter
</cfquery>

<cfquery name="Update" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Parameter
	SET    MovementNo = MovementNo+1
</cfquery>

<cfquery name="Line" 
	 datasource="appsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	  SELECT   *
	 FROM     Request 
	 WHERE    RequestId = '#URL.RequestID#'
</cfquery>	 

<cfquery name="Movement" 
	 datasource="appsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   AssetItem
	 WHERE  AssetId IN (#preservesinglequotes(Form.assetid)#)	
</cfquery>

<cfif Movement.recordcount gt "0">

	<cftransaction>
	
		<cf_assignId>
		
		<cfquery name="MovementRecord" 
		 datasource="appsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 INSERT INTO AssetMovement
		 (MovementId,
		  MovementCategory, 
		  Mission,
		  Reference, 
		  <cfif Form.Location neq "">
		  Location,
		  </cfif>
		  OrgUnit,
		  PersonNo,
		  ActionStatus,
		  OfficerUserId, 
		  OfficerLastName, 
		  OfficerFirstName) 
		 VALUES ('#rowguid#',
		         '002',
		         '#Line.Mission#',
		         '#Parameter.MovementPrefix#-#Parameter.MovementNo+1#',
				 <cfif Form.Location neq "">
				 '#Form.Location#',
				 </cfif>
				 '#Form.OrgUnit#',
				 '#Form.PersonNo#',
				 '0',
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')
		</cfquery>
				
		<!--- physical movement --->
		
		<cfif Form.Location neq "">
		
			<cfquery name="RemoveSame" 
			 datasource="appsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 DELETE FROM AssetItemLocation
			 WHERE  AssetId IN (#preservesinglequotes(Form.assetid)#)			
			 AND   DateEffective >= #dte#
			</cfquery>
		
			<cfquery name="InsertMovement" 
			 datasource="appsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 INSERT INTO AssetItemLocation
				 (AssetId, 
				 MovementId, 
				 Status, 
				 Location, 
				 DateEffective, 
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName)
			 SELECT AssetId, 
			        '#rowguid#', 
					'0', 
					'#Form.Location#',
					#dte#, 
					'#SESSION.acc#', 
					'#SESSION.last#', 
					'#SESSION.first#'
			 FROM AssetItem
		     WHERE  AssetId IN (#preservesinglequotes(Form.assetid)#)	
			</cfquery>
			
	</cfif>
	
	<!--- organizational movement --->
	
	<cfif Form.OrgUnit neq "" or Form.PersonNo neq "">
	    
		<cfquery name="RemoveSame" 
		 datasource="appsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 DELETE FROM AssetItemOrganization
		 WHERE  AssetId IN (#preservesinglequotes(Form.assetid)#)	
		 AND    DateEffective >= #dte#
		</cfquery>	
	
		<cfquery name="InsertMovement" 
		 datasource="appsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 INSERT INTO AssetItemOrganization
			 (AssetId, 
			  MovementId, 
			  RequestId,
			  ActionStatus, 
			  OrgUnit, 
			  PersonNo, 
			  DateEffective, 
			  OfficerUserId, 
			  OfficerLastName, 	  
			  OfficerFirstName)
			 SELECT AssetId, 
			        '#rowguid#', 
					'#url.requestid#',
					'0', 
					'#Form.OrgUnit#',
					'#Form.PersonNo#', 
					#dte#, 
					'#SESSION.acc#', 
					'#SESSION.last#', 
					'#SESSION.first#'
			 FROM   AssetItem
			 WHERE  AssetId IN (#preservesinglequotes(Form.assetid)#)	
		</cfquery>
		
	</cfif>
	
	<cfquery name="Check" 
		 datasource="appsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		  SELECT   count(*) as Count
		  FROM     AssetItemOrganization 
		  WHERE    RequestId = '#URL.RequestID#'
	</cfquery>	 
	
	<cfif Check.count gte Line.RequestedQuantity>
			
		<cfquery name="Update" 
			 datasource="appsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			  UPDATE  Request 
			  SET     Status = '3'
			  WHERE   RequestId = '#URL.RequestID#'
		</cfquery>	 
	
	</cfif>
	
   </cftransaction>

	<cfset link = "Warehouse/Application/Asset/Movement/MovementView.cfm?movementId=#rowguid#">
		
	<cf_ActionListing 
		    EntityCode       = "AssMovement"
			EntityClass      = "Standard"
			EntityGroup      = ""
			EntityStatus     = ""
			Mission          = "#Movement.Mission#"			
			ObjectReference  = "Equipment Movement Request"
			ObjectReference2 = ""
		    ObjectKey4       = "#rowguid#"
			ObjectURL        = "#link#"
			Show             = "No"
			CompleteFirst    = "No">
			
</cfif>

<script language="JavaScript">
	    window.close()
   		returnValue = 1
</script>

