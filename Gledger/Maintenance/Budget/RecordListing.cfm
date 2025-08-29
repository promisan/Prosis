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
<cf_divscroll>
 
<cfajaximport tags="cfwindow">

<script language="JavaScript" >
	
	function selectaccount(fund,object) {		
		ColdFusion.Window.create('mydialog', 'Maintain', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,center:true})    
		ColdFusion.Window.show('mydialog') 				
		ptoken.navigate('<cfoutput>#session.root#</cfoutput>/Gledger/Maintenance/Parameter/DefaultLedgerSelect.cfm?ID=Budget&ID1=' + fund + '&ID2='+object,'mydialog') 			
	}
	
	function refreshaccount(fund,object) {	
	}
	
	function listing(fd) {
	  
	    icM  = document.getElementById("d"+fd+"Min");
	    icE  = document.getElementById("d"+fd+"Exp");
	    se   = document.getElementsByName("row"+fd);
	  	cnt = 0
			 		 
		if (icM.className == "hide") {
		   	 icM.className = "regular";
		     icE.className = "hide";
			 while (se[cnt]) {
			   se[cnt].className = "navigation_row"
			   cnt++
			 }  		 
	        
		 } else {
		 	 icM.className = "hide";
		     icE.className = "regular";
	     	  while (se[cnt]) {
			   se[cnt].className = "hide"
			   cnt++
			 }  
		 }		 		
	  }

</script>

<cf_verifyOperational module = "Program" Warning   = "No">

<!---			
<cfif operational eq "0">

	<cf_message message="This functions is not enabled." return="Back">
	<cfabort>

</cfif>
--->

<!--- clean invalid codes --->

<cfquery name="Clean" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE FROM Ref_Accountreceipt
		WHERE  ObjectCode NOT IN (SELECT Code FROM Program.dbo.Ref_Object) 
</cfquery>

<cfquery name="Init" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     DISTINCT P.Fund, P.ObjectCode
	FROM       ProgramAllotmentdetail P 
	UNION
	SELECT     DISTINCT P.Fund, P.ObjectCode
	FROM       Purchase.dbo.RequisitionLineFunding P			      
</cfquery>

<cfloop query="Init">
	
	<cfquery name="Cur" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_Accountreceipt
		WHERE  Fund       = '#Fund#'
		AND    ObjectCode = '#ObjectCode#'
	</cfquery>
	
	<cfif cur.recordcount eq "0">		
		
		<cfquery name="Cur" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    INSERT INTO Ref_Accountreceipt
			(Fund,ObjectCode)
			VALUES ('#Fund#','#ObjectCode#')
		</cfquery>
		
	</cfif>

</cfloop>			

<cfquery name="SearchResult"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *,
	       A.Description as GLDescription, 
		   O.Description as Objectdescription
	FROM         Ref_Accountreceipt D INNER JOIN
                      Program.dbo.Ref_Object O ON D.ObjectCode = O.Code LEFT OUTER JOIN
                      Ref_Account A ON D.GLAccount = A.GLAccount
	WHERE O.Code = D.ObjectCode
	AND   O.Procurement = '1' 
	ORDER BY Fund,O.Code
</cfquery>

<table width="97%" cellspacing="0" cellpadding="0" >

<cfset Page         = "0">
<cfset add          = "0">
<cfset Header       = "Allotment GL Conversion">
<cfinclude template = "../HeaderMaintain.cfm"> 

<tr>

<td colspan="2">

<table width="97%" align="center" align="center" class="navigation_table">

<tr class="labelmedium line">
    <td width="20"></td>
    <td width="60">Fund</td>
	<td width="39%">Object of expenditure</td>
	<td width="6%"></td>
	<td width="39%">GL Account</td>
</tr>

<cfoutput query="SearchResult" group="Fund">

<tr class="navigation_row">
  
	<td align="center" onClick="listing('#Fund#')">
	
	<img src="#SESSION.root#/Images/toggle_up.png" alt="" 
			name="d#Fund#Exp" id="d#Fund#Exp" <!---id="d#OrgUnit#Exp" --->
			border="0" 
			align="absmiddle"
			class="regular" style="cursor: pointer;" >
			 
		<img src="#SESSION.root#/Images/toggle_down.png" 
			id="d#Fund#Min" alt="" border="0" 
			align="absmiddle"
			class="hide" style="cursor: pointer;" 
			onClick="">
	</td>			
	
	<td style="height:35px;cursor: pointer;" class="labellarge" onClick="listing('#Fund#')">#Fund#</td>
	<td colspan="3"></td>
	
</tr>

<cfoutput>
	    
	<tr id="row#fund#" name="row#fund#" class="hide">
	
	    <td align="center"></td>	
		<td class="labelit"><!--- #currentrow# ---></td>	
		<td class="labelit">#ObjectCode# #Objectdescription#</td>
		<td align="center" style="padding-top:1px;">		
		<cf_img icon="delete" onclick="_cf_loadingtexthtml='';ptoken.navigate('Recordreset.cfm?fund=#Fund#&objectcode=#ObjectCode#','cell#fund#_#objectcode#')">		 
		<td class="labelit" id="cell#fund#_#objectcode#">
		  <cfif glaccount eq "">
	    	<a href="javascript:selectaccount('#Fund#','#ObjectCode#')"><font color="FF0000">Click here to associate</a></font>
			<cfelse>
			#GLAccount# #GLDescription#
	   	  </cfif>
		</td>		
		<!--- template to refresh --->
		<td	class="hide" id="refresh#fund#_#objectcode#" 
		onclick="_cf_loadingtexthtml='';ptoken.navigate('RecordUpdate.cfm?fund=#Fund#&objectcode=#ObjectCode#','cell#fund#_#objectcode#')"></td>
		
	</tr>
	
</CFOUTPUT>

<tr><td colspan="5" class="line"></td></tr>

</CFOUTPUT>

</table>

</td>

</tr>

</table>

