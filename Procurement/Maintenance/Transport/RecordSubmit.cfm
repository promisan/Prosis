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
<cfif ParameterExists(Form.Tracking)>
	<cfset Tracking= "#Form.Tracking#" >
<cfelse>
	<cfset Tracking = 0>
</cfif>  


<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_transport
WHERE Code  = '#Form.Code#' 

</cfquery>

    <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("An record with this code has been registered already!")
     
   </script>  
  
   <CFELSE>
   
<CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="Ref_transport" 
ActionType="Enter" 
ActionReference="#Form.code#" 
ActionScript="">      
   
<cfquery name="Insert" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_transport
         (Code,
		 Description, 
		 Tracking, 
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.Code#', 
          '#Form.Description#',
		  '#Tracking#',
		  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate())
</cfquery>
	xxxxx	  
	</cfif>	  

</cfif>

<cfif ParameterExists(Form.Update)>

<CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="Ref_transport" 
ActionType="Update" 
ActionReference="#Form.code#" 
ActionScript="">       

<cfquery name="Update" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_transport
SET Description  = '#Form.Description#' ,
Tracking = '#Tracking#',
Code='#Form.Code#'
WHERE Code = '#Form.CodeOld#'
</cfquery>

</cfif>


<cfif ParameterExists(Form.Delete)> 

    <cfquery name="CountRec" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT    *
     FROM     Purchase
     WHERE    transportation = '#Form.Code#' 
	 </cfquery>
	
    <cfif #CountRec.recordCount# gt 0 >
		 
     <script language="JavaScript">
    
	   alert(" Type of transportation is in use. Operation aborted.")
     
     </script>  
	 	 
    <cfelse>
	
	

 <CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="Ref_transport" 
ActionType="Remove" 
ActionReference="#Form.code#" 
ActionScript="">   
		
	<cfquery name="Delete" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM Ref_transport
WHERE Code   = '#Form.code#'
    </cfquery>
	
    </cfif>	
	
</cfif>	
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  