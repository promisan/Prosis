<cfoutput>

<cf_tl id="Position Lookup" var="1">

<cfinclude template="../../../../Vactrack/Application/Document/Dialog.cfm">

<cf_screenTop height="100%" title="#lt_text#" jQuery="Yes" border="0" band="No" scroll="no" html="No">
   
<cf_layoutscript>

<cfajaximport tags="cfform">

<cfoutput>  

	<script language="JavaScript">
	
		function reloadTree(man) {
	        ptoken.navigate('PositionTree.cfm?&ApplicantNo=#URL.ApplicantNo#&PersonNo=#URL.PersonNo#&RecordId=#URL.RecordId#&DocumentNo=#URL.DocumentNo#&source=#url.source#&Mission=#URL.Mission#&MandateNo='+man,'tree');
	    }
	
		function clearno() 
			{ document.getElementById("find").value = "" }
	
		function search() {
			
		 se = document.getElementById("find")	
		 if (window.event.keyCode == "13") {	
		    findme()		
			}						
	    }
		
		function findme() {		
			val = document.getElementById("find").value
			man = document.getElementById("selectedmandate").value			
			ptoken.navigate('PositionListing.cfm?ID=#url.source#&ID1='+val+'&ID2=#URL.Mission#&ID3='+man+'&Source=#URL.Source#&ApplicantNo=#URL.ApplicantNo#&PersonNo=#URL.PersonNo#&RecordId=#URL.RecordId#&DocumentNo=#URL.DocumentNo#','listresult')
		
		}
	
		function assignment(source, positionno, applicantno, personno, recordid, documentno) {
			
		     <cfif url.source eq "vac">			    
		     	ptoken.location('#SESSION.root#/Staffing/Application/Assignment/AssignmentEntry.cfm?source=' + source + '&id=' + positionno + '&applicantno=' + applicantno + '&personno=' + personno + '&recordid=' + recordid + '&documentno=' + documentno); 
		       //ptoken.open("#SESSION.root#/Staffing/Application/Assignment/AssignmentEntry.cfm?ts="+new Date().getTime()+"&source=" + source + "&id=" + positionno + "&applicantno=" + applicantno + "&personno=" + personno + "&recordid=" + recordid + "&documentno=" + documentno, "_top");
			 <cfelse>
			 ptoken.open("#SESSION.root#/Staffing/Application/Assignment/AssignmentEntry.cfm?ts="+new Date().getTime()+"&source=" + source + "&id=" + positionno + "&applicantno=" + applicantno + "&personno=" + personno + "&recordid=" + recordid + "&documentno=" + documentno, "PositionLookup");		 
			 </cfif>
		}
		
		function transfer(source, positionno, personno, assignmentno, positionold) {		
		    ptoken.open("#SESSION.root#/Staffing/Application/Assignment/AssignmentEdit.cfm?source=" + source + "&positionno=" + positionno + "&id=" + personno + "&Caller=P&id1=" + assignmentno + "&positionold=" + positionold, "_parent");
		}
		
		function associate(source, positionno, recordid, documentno) {
		    ptoken.open("#SESSION.root#/Staffing/Application/PostMatching/PostAssociate.cfm?source=" + source + "&positionno=" + positionno + "&recordid=" + recordid + "&documentno=" + documentno, "PositionLookup");
		}
		
		<cfif URL.Source eq "Lookup"> 
		
			function lookupreturn(mis,postnum,funno,funct,unit,grade,position) {	
			
			   	var form = "#trim(URL.FormName)#";
				var pst = "#URL.fldPostNumber#";
				var fno = "#URL.fldFunctionNo#";
				var fun = "#URL.fldFunction#";
				var org = "#URL.fldOrgUnit#";
			    var grd = "#URL.fldGrade#";
				var pos = "#URL.fldPosNo#";
				
				<!--- corrected again hanno --->
					
				eval("parent.opener.document." + form + "." + pst + ".value = '" + postnum + "'");
				eval("parent.opener.document." + form + "." + fno + ".value = '" + funno + "'");
				eval("parent.opener.document." + form + "." + fun + ".value = '" + funct + "'");
				eval("parent.opener.document." + form + "." + org + ".value = '" + unit + "'");
				eval("parent.opener.document." + form + "." + grd + ".value = '" + grade + "'");
				eval("parent.opener.document." + form + "." + pos + ".value =" + position);
				parent.window.close();
			    }
			
		</cfif>	
	
	</script>
	
</cfoutput>		

<cfif URL.Source eq "VAC">

	<!--- retrieve position --->
	
	<cfif URL.MandateNo eq "0000">

		<cfquery name="Mandate" 
		datasource="AppsOrganization" 
		maxrows=1 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Ref_Mandate
			WHERE    Mission = '#url.Mission#'
			ORDER BY MandateDefault DESC, MandateNo DESC
		</cfquery>
		  
		<cfset MandateDefault = Mandate.MandateNo>	
	
	<cfelse>
	
		<cfquery name="Mandate" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_Mandate
			WHERE  Mission = '#url.Mission#'
			AND    MandateNo = '#URL.MandateNo#'
		</cfquery>
	
		<cfset MandateDefault = URL.MandateNo>	
	
	</cfif>

	<cfquery name="Position" 
	   datasource="AppsVacancy" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   
		 SELECT    *
		   FROM    Employee.dbo.Position Post INNER JOIN
		           DocumentPost D ON Post.PositionNo = D.PositionNo INNER JOIN
		           Organization.dbo.Organization Org ON Post.OrgUnitOperational = Org.OrgUnit	     
			WHERE  D.DocumentNo    = '#URL.DocumentNo#'	
		     AND   Org.Mission     = '#URL.Mission#'
			 AND   Org.MandateNo   = '#MandateDefault#'
			 
		 UNION
		 
		 SELECT    * 
		 FROM      Employee.dbo.Position Post INNER JOIN
		           DocumentPost D ON Post.SourcePositionNo = D.PositionNo INNER JOIN
		           Organization.dbo.Organization Org ON Post.OrgUnitOperational = Org.OrgUnit				  
		 WHERE     D.DocumentNo    = '#URL.DocumentNo#'		
		    AND    Org.Mission     = '#URL.Mission#'
			AND    Org.MandateNo   = '#MandateDefault#'		
					
		</cfquery>
	
		<cfif position.recordcount eq "0">
	  	    <cfset col = "false">		
		<cfelse>
			<cfset col = "true">	  
		</cfif>

<cfelse>

	<cfset col = "false">

</cfif>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}> 

<cf_layout attributeCollection="#attrib#"> 

	<!---
	<cf_layoutarea  position="top" name="menu" overflow="hidden" splitter="true" minsize="50" maxsize="50">
		  		  
			<cf_ViewTopMenu background="gray" user="No" label="Select Onboarding Position">
						
	</cf_layoutarea>
	--->
	
	<cf_layoutarea 
	    position    = "left" 
		name        = "treebox" 
		maxsize     = "370" 		
		size        = "300" 
		collapsible = "true" 
		splitter    = "true"
		overflow    = "scroll">
	
			<cfinclude template="PositionTree.cfm">
						
	</cf_layoutarea>
	
	<cf_layoutarea 
          position="center"
          name="content"
          overflow="auto">		  	
	   
			<cf_divscroll style="height:100%;padding-right:4px">			
			<table width="97%" height="100%" style="padding-left:20px;padding-right:20px">				
			<tr><td id="listresult" style="padding-top:5px" valign="top" align="center" height="100%" class="labelmedium">	
				<cfinclude template="PositionListing.cfm">				
				</td>
			</tr>
			</table>	
			</cf_divscroll>				
					
	</cf_layoutarea>			
	
</cf_layout>	

</cfoutput>

