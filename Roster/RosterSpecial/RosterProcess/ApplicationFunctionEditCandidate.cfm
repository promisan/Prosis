
<table width="100%" border="0" cellspacing="0" cellpadding="0">
   
   <tr>

   <td width="100%" colspan="2">

   <table width="100%">

   <tr bgcolor="EaEaEa" style="border:1px solid silver">
   
   	<td valign="top" id="picturebox" style="width:5%;padding:2px">  
					
		<cfinvoke component="Service.Access"  
		   method="roster" 
		   returnvariable="AccessRoster"
		   role="'AdminRoster','CandidateProfile'">		

		<cfif AccessRoster eq "EDIT" or AccessRoster eq "ALL">
									    
				<cf_PictureView documentpath="Applicant"
	                subdirectory="#PersonNo#"
					filter="Picture_" 							
					width="90" 
					height="120" 
					mode="edit">	
					
							
		<cfelse>
			
				<cf_PictureView documentpath="Applicant"
	                subdirectory="#PersonNo#"
					filter="Picture_" 							
					width="90" 
					height="120" 
					mode="view">					
											
		</cfif>		
						
 		</td>
  
    <td valign="top" style="padding-left:6px;padding-top:5px;padding-bottom:6px">
	
	   <cfoutput query="Get" maxrows=1>
	
	    <table width="100%" border="0">
	  					 
	     <TR>
		   
		     <td colspan="4" class="labellarge" style="height:28px">
			    <a title="candidate profile" href="javascript:ShowCandidate('#PersonNo#')"><b>#FirstName# #LastName# #gender#</a>
			 </td>
			
		</tr>
				
		<TR>
	    <td style="padding-left:5px" width="110" class="labelit"><cfoutput>#client.IndexNoName#</cfoutput>:</td>
	    <TD colspan="1" class="labelmedium" style="height:22px;padding-right:10px;">
		<cfif Employee.PersonNo neq "">
		<A HREF ="javascript:EditPerson('#Employee.PersonNo#')"><font color="0080C0">#Get.IndexNo#</a>
		<cfelse>#IndexNo# 
		</cfif>
		</TD>
		<td width="110" class="labelit"><cf_tl id="Email">:</td>
	    <TD colspan="1" class="labelmedium fixlength" style="height:22px;padding-right:10px;">
		<cfloop index="itm" list="#EMailAddress#" delimiters=",">#itm#<br></cfloop>
		</TD>
		
		</tr>
						
		<TR>
		
	    <td style="padding-left:5px" width="150" class="labelit"><cf_tl id="Organization">:</td>
	    <td colspan="1" class="labelmedium fixlength" style="height:22px">
		
		<cfif Organization.Mission is not ''>#Organization.Mission#<cfelse>#Organization.OrgUnitName#</cfif></TD>
					  			   
		   <cfquery name="Status" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
			    FROM    Ref_PersonStatus
			    WHERE   Code = '#Status.PersonStatus#'
			</cfquery>
		 
	        <td class="labelit"><cf_tl id="Status">:</b></td>
	        <td class="labelmedium fixlength" style="height:22px" bgcolor="#Status.InterfaceColor#">
			<cfif status.description eq "">
			n/a
			<cfelse>
			<cfif Status.InterfaceColor neq "Transparent"><font color="silver"></cfif>#Status.Description#
			</cfif>
			</td>
			    	
		</tr>
		
		<tr>		
	    <td style="padding-left:5px" width="150" class="labelit"><cf_tl id="Nationality">:</td>
	    <td class="labelmedium fixlength" style="height:22px">		
				  			   
		   <cfquery name="Nation" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
			    FROM   Ref_Nation
			    WHERE  Code = '#Nationality#'
			</cfquery>	
		
			#Nation.Name#
		
		</td>
		<td width="150" class="labelit"><cf_tl id="Date of Birth">:</td>
	    <td class="labelmedium" style="height:22px">#dateFormat(DOB,CLIENT.DateFormatShow)#</td>		
		</tr>
					
		<tr>
	    <td style="padding-left:5px" width="150" class="labelit"><cf_tl id="Staff grade/level">:</td>
	    <td class="labelmedium" style="height:22px">
		<cfif LastGrade.ContractLevel eq "">n/a
		<cfelse>
			#LastGrade.ContractLevel#/#LastGrade.ContractStep#
		</cfif>
		</td>
		<td width="150" class="labelit"><cf_tl id="Class">:</td>
	    <td colspan="1" class="labelmedium" style="height:22px">
		
			<cfquery name="Class" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   Ref_ApplicantClass
				WHERE  ApplicantClassId = '#ApplicantClass#'
			</cfquery>		
			#Class.Description#
			
		</td>		
		</tr>
		
		</table>
	
	</td>
			
	</cfoutput>
		
	</tr>	
		
</table>