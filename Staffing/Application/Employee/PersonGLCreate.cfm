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

<!--- create GL Account --->

<cftransaction>

<cfquery name="Area" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  *
		  FROM    Ref_AreaGLedger
		  WHERE   Area     = '#url.Area#'
</cfquery>		

<cfif Area.AccountSerialNo neq "0">

	<cfset ser = Area.AccountSerialNo+1>
		
	<cfquery name="Set" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  UPDATE Ref_AreaGLedger
		  SET AccountSerialNo = AccountSerialNo+1
		  WHERE   Area     = '#url.Area#'
	</cfquery>		
	
<cfelse>

	<cfset ser = "#Person.PersonNo#">
	
</cfif>

<cfquery name="Person" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  *
		  FROM    Person
		  WHERE   PersonNo  = '#url.PersonNo#'
</cfquery>	

<cfquery name="Group" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  *
		  FROM    Accounting.dbo.Ref_AccountGroup
		  WHERE   AccountGroup  = '#Area.AccountGroup#'
</cfquery>			

<cfif Area.AccountPrefix eq "" or Area.AccountGroup eq "" or Group.recordcount eq "0">

	<!--- do nothing --->
	
<cfelse>

<!--- create account --->
			
	 <cfquery name="Check" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Accounting.dbo.Ref_Account
		WHERE  GLAccount = '#Area.AccountPrefix##ser#'		
     </cfquery>	
	 
	 <cfif Check.recordcount eq "0">
		
		<cfquery name="Insert" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Accounting.dbo.Ref_Account
			         (GLAccount,
					 Description,
					 AccountGroup,
					 AccountType,
					 AccountClass,			
					 MonetaryAccount,			 
					 BankReconciliation,			 
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
		  VALUES ('#Area.AccountPrefix##ser#', 
		          '#Person.FirstName# #Person.LastName#',
				  '#Area.AccountGroup#',
				  '#Group.AccountType#',
				  '#Group.AccountClass#',			  	
				  '0',			  
				  '0',			  
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		  </cfquery>	
		  
		</cfif>  
		  
	    <cfquery name="Insert" 
		  datasource="AppsEmployee" 
   		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  INSERT INTO PersonGLedger
		         (PersonNo,Area,GLAccount)
		  VALUES ('#URL.PersonNo#',
		          '#URL.Area#',
				  '#Area.AccountPrefix##ser#')
		 </cfquery>	
		 			
</cfif>	

<cfquery name="Account" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  P.*, A.Description
		  FROM    PersonGLedger P, Accounting.dbo.Ref_Account A
		  WHERE   PersonNo = '#url.PersonNo#'
		  AND     Area     = '#url.Area#'
		  AND     P.GLAccount = A.GLAccount
</cfquery>		

<cfoutput>	

	<cfif Account.recordcount eq "0">
	
		<table><tr class="labelmedium"><td><font color="FF0000">Not supported</td></tr></table>
	
	<cfelse> 

		<table cellspacing="0" cellpadding="0">
		<tr>	
			<td>  	  
		      <input type="text" name="#url.Area#" id="#url.Area#" 
				 size="8"  value="#Account.glaccount#"     
				 class="regularxl" 
				 readonly style="text-align: center;">
		    </td>
			<td style="padding-left:2px">
				<input type="text" name="#url.Area#description" id="#url.Area#description" 
				 value="#Account.Description#" 
				 class="regularxl" 
				 size="40" 
				 readonly style="text-align: center;">
			</td>
			<td style="padding-left:2px">	
							
		      <img src="#SESSION.root#/Images/search.png" name="img3#url.area#" 
				  onMouseOver="document.img3#url.area#.src='#SESSION.root#/Images/contract.gif'" 
				  onMouseOut="document.img3#url.area#.src='#SESSION.root#/Images/search.png'"
				  style="cursor: pointer;" width="27" height="27" border="0" align="absmiddle" 
				  onClick="selectaccountgl('','glaccount','','','applyglaccount','#url.Area#');">
				  
			</td>
		</tr>
		</table>	 	 
		<input type="hidden" name="#url.Area#cls" id="#url.Area#cls">
		
	</cfif>	
	
</cfoutput>	

</cftransaction>