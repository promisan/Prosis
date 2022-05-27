
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="URL.DocId" default="">

<cfquery name="Init" 
datasource="AppsInit">
	SELECT * 
	FROM   Parameter
	WHERE  HostName = '#cgi.http_host#'		
</cfquery>

<cfparam name="documentpagesize" default="Letter">

<cfquery name="Object" 
	 datasource="AppsOrganization">
	 SELECT *
	 FROM   OrganizationObject
	 WHERE  ObjectId IN (SELECT ObjectId FROM organizationObjectAction WHERE Actionid = '#url.id#')	
</cfquery>

<cfset Subject = "#Object.ObjectReference2#: #Object.ObjectReference#">

<cfif url.docid eq "">
	
	<cfquery name="Action" 
	 datasource="AppsOrganization">
	 SELECT *, ActionMemo as DocumentContent
	 FROM  OrganizationObjectAction OA
	 WHERE ActionId = '#URL.ID#' 	
	</cfquery>
	
	<cfset vDocumentscale        = "92">		

<cfelse>
	
	<cfquery name="Action" 
	 datasource="AppsOrganization">
	 SELECT OA.*, OAP.*
	 FROM   OrganizationObjectAction OA,
	        OrganizationObjectActionReport OAP
	 WHERE  OA.ActionId    = '#URL.ID#' 
	  AND   OA.ActionId    = OAP.ActionId 	
	  AND   OAP.DocumentId = '#URL.DocId#' 	
	</cfquery>
	
	<cfquery name="qDocument" 
	 datasource="AppsOrganization">
	  SELECT * 
	  FROM   Ref_EntityDocument
	  WHERE  DocumentId = '#Action.DocumentId#'	  
	 </cfquery>	
	
	<cfset documentpagesize      = Action.DocumentFormat>
	<cfset vDocumentscale        = qDocument.Scale>		

</cfif>

<cfif documentpagesize eq "">
	<cfif Init.ReportPageType neq "">
		<cfset documentpagesize = Init.ReportPageType>	
	</cfif>	
</cfif>

<cfquery name="ActionFlow" 
 datasource="AppsOrganization">
 SELECT ActionDescription
 FROM   Ref_EntityActionPublish
 WHERE  ActionPublishNo = '#Action.ActionPublishNo#' 
 AND    ActionCode = '#Action.ActionCode#'
</cfquery>

<cfquery name="Entity" 
 datasource="AppsOrganization">
 SELECT *
 FROM  Ref_Entity R, 
       Ref_EntityClassPublish P
 WHERE R.EntityCode = P.EntityCode
 AND   P.ActionPublishNo = '#Action.ActionPublishNo#' 
</cfquery>

<cfset attach = "">

<!--- move step attachment into temp directory --->

<cfdirectory action="LIST" 
	directory="#SESSION.rootDocumentPath#\#Entity.EntityCode#\#URL.ID#" 
	name="GetFiles" 
	sort="DateLastModified DESC" 
	filter="">
				
<cfloop query="GetFiles">

	<cffile action  = "COPY" 
	        source  = "#SESSION.rootDocumentPath#\#Entity.EntityCode#\#URL.ID#\#Name#" 
			destination= "#SESSION.rootPath#/CFRStage/User/#SESSION.acc#/#Name#">
	
	<cfif attach eq "">
	   <cfset attach = "#Name#">
	<cfelse>
	   <cfset attach = "#Attach#,#Name#">
	</cfif>	
									
</cfloop>

<cfquery name="Org" 
 datasource="AppsOrganization">
 SELECT *
 FROM Organization
 WHERE OrgUnit = '#Action.OrgUnit#' 
</cfquery>

<cfoutput query="Action">

	<cfset FileNo = round(Rand()*20)>

	<cfif url.docid eq "">
		
		<cfif Entity.DefaultFormat eq "HTML">
		    <cfset filename = "memo_#FileNo#.htm">		
		<cfelse>
		    <cfset filename = "memo_#FileNo#">
		</cfif>	
		<cfset password = "">
	
	<cfelse>
		
		<cfquery name="Name" 
		 datasource="AppsOrganization">
		 SELECT *
		 FROM Ref_EntityDocument
		 WHERE EntityCode = '#Entity.EntityCode#' 
		 AND   DocumentId = '#DocumentId#' 
		</cfquery>
		
		<cfif Name.DocumentDescription neq "">
		
			<cfif Entity.DefaultFormat eq "HTML">
		    	<cfset filename = "memo_#FileNo#.htm">			
			<cfelse>
		   		 <cfset filename = "#Name.DocumentDescription#_#FileNo#">
			</cfif>	
			<cfset password = "#Name.DocumentPassword#">
			
		<cfelse>	
		
			<cfif Entity.DefaultFormat eq "HTML">
		    	<cfset filename = "memo_#FileNo#.htm">			
			<cfelse>
		    	<cfset filename = "doc_#FileNo#">
			</cfif>	
			<cfset password = "">		
		
		</cfif>	
	
	</cfif>
	
	<cfif Entity.DefaultFormat eq "HTML">
	
		<cfif attach eq "">
		   <cfset attach = "#fileName#">
		<cfelse>    
		   <cfset attach = "#Attach#,#FileName#">
		</cfif>	
	
	<cfelse>
	
		<cfif attach eq "">
		   <cfset attach = "#fileName#.pdf">
		<cfelse>    
		   <cfset attach = "#Attach#,#FileName#.pdf">
		</cfif>	
	
	</cfif>
			
	<cfif Entity.DefaultFormat neq "HTML">
	
	     <!---
		    
		<cfdocument 
		      format       = "#Entity.DefaultFormat#"
		      pagetype     = "#documentpagesize#"
			  overwrite    = "yes"
			  filename     = "#SESSION.rootPath#/CFRStage/User/#SESSION.acc#/#fileName#"
			  margintop    = "0.4"
		      marginbottom = "1.0"
		      marginright  = "0.4"
		      marginleft   = "0.4"
			  encryption   = "128-bit"
			  userpassword = "#password#"
		      orientation  = "portrait"
		      unit         = "cm"
		      fontembed    = "Yes"
		      scale        = "#vdocumentscale#"
		      backgroundvisible="Yes">
		
		<cfdocumentitem type="footer">
		
			<cfoutput>
			
			<table width="100%" style="height:14px">
				<tr class="labelmedium">
				<td style="font-size:13px" valign="bottom">#session.first# #session.last# #dateformat(now(),client.dateformatshow)# #timeformat(now(),"HH:MM")#</td>
				<td style="font-size:13px" valign="bottom" align="right"><cf_tl id="Page"> #cfdocument.currentpagenumber# <cf_tl id="of"> #cfdocument.totalpagecount#</td>
				</tr>
				</table>				
			
			</cfoutput>
			
		</cfdocumentitem>
		
		<!---	
		<table width="100%">
		<tr>
		   <td style="font-size: xx-small;">Name:</td>
		   <td style="font-size: xx-small;">#Action.OfficerFirstName# #Action.OfficerLastName#</td>
		</tr>
		<tr><td height="2" colspan="2" bgcolor="silver"></td></tr>
		</table>
			
		
		<table width="100%">
		<tr>
		   <td style="font-size: xx-small;">Action</td>
		   <td style="font-size: xx-small;">#Action.ActionDescription#</td>
		</tr>
		<tr>
		   <td style="font-size: xx-small;">Date</td>
		   <td style="font-size: xx-small;">#DateFormat(Action.OfficerDate, CLIENT.DateFormatShow)#</td>
		</tr>
		
		<tr><td height="2" colspan="2" bgcolor="silver"></td></tr>
		<tr><td colspan="2"></td></tr>
		</table>
		
		--->
		
		<cfset text = replace("#DocumentContent#", "@pb", "<p style='page-break-after:always;'>&nbsp;</p>", "ALL")>
		<cfif text neq "">
			#text#
		<cfelse>
			&nbsp;
		</cfif>
		
		<!---	
		<cftry>				
			  <cffile action = "delete"
			  file = "#SESSION.rootpath#\CFRStage\User\#SESSION.acc#\#SESSION.acc#readme.cfm"> 
			  <cfcatch></cfcatch>
		</cftry>	  
								    
		<cffile action = "append"
			     file = "#SESSION.rootpath#\CFRStage\User\#SESSION.acc#\#SESSION.acc#readme.cfm"
		         output = "#text#"
		         addNewLine = "Yes">  
					 
		<cfinclude template="../../CFRStage/User/#SESSION.acc#/#SESSION.acc#readme.cfm">
		
		<cffile action = "delete"
			 	  file = "#SESSION.rootpath#\CFRStage\User\#SESSION.acc#\#SESSION.acc#readme.cfm">  
				  
				  --->
			
		</cfdocument>
		
		--->
		
		<cfset text = replace("#DocumentContent#", "@pb", "<p style='page-break-after:always;'>&nbsp;</p>", "ALL")>
				
		  <cftry>		
			<cfdirectory action="CREATE" directory="#SESSION.rootDocumentPath#\CFRStage\User\#Session.acc#\">
			<cfcatch></cfcatch>
	   	  </cftry>	 
		 
		  <cffile action="WRITE" 
		        file="#SESSION.rootDocumentPath#\CFRStage\User\#Session.acc#\#fileName#.htm" 
			    output="#text#" 
				addnewline="Yes" 
			    fixnewline="No">										 
	
		  <!--- NEW on-the-fly converter of htm content to pdf --->  
	      <cf_htm_pdf fileIn="#SESSION.rootDocumentPath#\CFRStage\User\#Session.acc#\#fileName#">
		
	 	  <cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
		  <cfset mid = oSecurity.gethash()/>			
		
	<cfelse>
	
		<cfset text = replace("#DocumentContent#", "@pb", "<tr style='page-break-after: always;'><p></p></tr>", "ALL")>	
		<cfsavecontent variable="mailfile">#Text#</cfsavecontent>
	
		<cftry>
		
			<cffile action="DELETE" file="#SESSION.rootPath#/CFRStage/User/#SESSION.acc#/#fileName#">
		
		<cfcatch></cfcatch>
		
		</cftry>
	
		<cffile action="WRITE"
		   file="#SESSION.rootPath#/CFRStage/User/#SESSION.acc#/#fileName#" 
		   output="#mailfile#" 
		   addnewline="Yes" 
		   fixnewline="No">	   
		
	</cfif>	

</cfoutput>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<cfoutput>

	<script language="JavaScript">
			window.location = "#SESSION.root#/Tools/Mail/Mail.cfm?ID1=#subject#&ID2=#attach#&Source=Action&Sourceid=#URL.ID#&Mode=Dialog&GUI=HTML&mid=#mid#"
	</script>

</cfoutput>
