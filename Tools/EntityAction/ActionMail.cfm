
<cf_sleep>
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
<cf_wait text="please wait, while preparing the attachment">

<cfparam name="URL.DocId" default="">

<cfif url.docid eq "">
	
	<cfquery name="Action" 
	 datasource="AppsOrganization">
	 SELECT *, ActionMemo as DocumentContent
	 FROM  OrganizationObjectAction OA
	 WHERE ActionId = '#URL.ID#' 	
	</cfquery>

<cfelse>
	
	<cfquery name="Action" 
	 datasource="AppsOrganization">
	 SELECT OA.*, OAP.*
	 FROM  OrganizationObjectAction OA,
	       OrganizationObjectActionReport OAP
	 WHERE OA.ActionId    = '#URL.ID#' 
	  AND  OA.ActionId    = OAP.ActionId 	 	
	</cfquery>

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
		<cfelseif Entity.DefaultFormat eq "FlashPaper">
			<cfset filename = "memo_#FileNo#.swf">
		<cfelse>
		    <cfset filename = "memo_#FileNo#.pdf">
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
			<cfelseif Entity.DefaultFormat eq "FlashPaper">
				 <cfset filename = "#Name.DocumentDescription#_#FileNo#.swf">
			<cfelse>
		   		 <cfset filename = "#Name.DocumentDescription#_#FileNo#.pdf">
			</cfif>	
			<cfset password = "#Name.DocumentPassword#">
			
		<cfelse>	
		
			<cfif Entity.DefaultFormat eq "HTML">
		    	<cfset filename = "memo_#FileNo#.htm">
			<cfelseif Entity.DefaultFormat eq "FlashPaper">
				<cfset filename = "doc_#FileNo#.swf">
			<cfelse>
		    	<cfset filename = "doc_#FileNo#.pdf">
			</cfif>	
			<cfset password = "">		
		
		</cfif>	
	
	</cfif>
	
	<cfif attach eq "">
	   <cfset attach = "#fileName#">
	<cfelse>
	   <cfset attach = "#Attach#,#FileName#">
	</cfif>	
	
	<cfif Entity.DefaultFormat neq "HTML">
		    
		<cfdocument 
		      format       = "#Entity.DefaultFormat#"
		      pagetype     = "letter"
			  overwrite    = "yes"
			  filename     = "#SESSION.rootPath#/CFRStage/User/#SESSION.acc#/#fileName#"
			  margintop    = "0.4"
		      marginbottom = "0.4"
		      marginright  = "0.4"
		      marginleft   = "0.4"
			  encryption   = "128-bit"
			  userpassword = "#password#"
		      orientation  = "portrait"
		      unit         = "cm"
		      fontembed    = "Yes"
		      scale        = "98"
		      backgroundvisible="Yes">
		
		<cfdocumentitem type="footer">
			<cfoutput>
			Page #cfdocument.currentPagenumber#
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

<cfoutput>

	<cf_waitEnd>

	<script language="JavaScript">
			window.location = "#SESSION.root#/Tools/Mail/Mail.cfm?ID1=#ActionFlow.ActionDescription#&ID2=#attach#&Source=Action&Sourceid=#URL.ID#&Mode=Dialog&GUI=HTML"
	</script>

</cfoutput>

</body>