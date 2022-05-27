<cfparam name="URL.DocId"             default="">
<cfparam name="URL.Mode"              default="pdf">
<cfparam name="URL.Format"            default="">

<cfquery name="Init" 
datasource="AppsInit">
	SELECT * 
	FROM   Parameter
	WHERE  HostName = '#cgi.http_host#'		
</cfquery>

<cfparam name="documentpagesize" default="Letter">

<cfif url.docid eq "">
	
	<cfquery name="Action" 
	 datasource="AppsOrganization">
	 
	 SET    TextSize 1000000
	 
	 SELECT *, ActionMemo as DocumentContent
	 FROM   OrganizationObjectAction OA
	 WHERE  ActionId = '#URL.ID#' 	
	 
	</cfquery>
	
	<cfset documentheader        = "">
	<cfset documentfooter        = "">	
	<cfset vDocumentmargintop    = "0.5">
	<cfset vDocumentmarginbottom = "0.5">	
	<cfset documentorientation   = "Vertical">

	<cfset documentName = "">
	<cfset vDocumentscale = "95">		
	
<cfelse>
	
	<cfquery name="Action" 
	 datasource="AppsOrganization">
	 	SET TextSize 1000000  

		 SELECT    OA.ActionCode, 
		           OA.OrgUnit, 
				   OA.ActionPublishNo, 
				   OAP.*
		 FROM      OrganizationObjectAction OA,
		           OrganizationObjectActionReport OAP
		 WHERE     OA.ActionId = '#URL.ID#' 
		  AND      OA.ActionId = OAP.ActionId
		  AND      OAP.DocumentId = '#URL.DocId#' 	  			  
	</cfquery>	

	<cfquery name="qDocument" 
	 datasource="AppsOrganization">
	  SELECT * 
	  FROM   Ref_EntityDocument
	  WHERE  DocumentId = '#URL.DocId#'	  
	 </cfquery>	
	 
 	<cfset documentorientation   = qDocument.DocumentOrientation>	 
	<cfset documentName          = qDocument.DocumentDescription>	
	<cfset documentpagesize      = Action.DocumentFormat>
	
	<cfif len(action.documentHeader) gte "5" and action.documentMarginTop neq "0">
		<cfset vDocumentmargintop    = "#action.documentMarginTop#">
	<cfelse>
		<cfset vDocumentmargintop    = "#qDocument.MarginTop#">
	</cfif>
	
	<cfif len(action.documentFooter) gte "5" and action.documentMarginBottom neq "0">
		<cfset vDocumentmarginbottom = Action.documentMarginBottom>		
	<cfelse>
		<cfset vDocumentmarginbottom = qDocument.MarginBottom>		
	</cfif>	
	
	<cfset vDocumentscale            = qDocument.Scale>			
	
</cfif>

<cfif documentpagesize eq "">
	<cfif Init.ReportPageType neq "">
		<cfset documentpagesize = Init.ReportPageType>	
	</cfif>	
</cfif>

<cfquery name="qTitle" 
 datasource="AppsOrganization">
 SELECT TOP 1 OO.* 
 FROM   OrganizationObject OO INNER JOIN 
	    OrganizationObjectAction OA ON 
		OO.ObjectId = OA.ObjectId
 WHERE OA.ActionId = '#URL.ID#' 	
</cfquery>

<cfoutput>
	<title>#documentName# #qTitle.ObjectReference# #qTitle.ObjectReference2#</title>
</cfoutput>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfswitch expression="#documentorientation#">
	<cfcase value="Horizontal">
		<cfset documentorientation = "Landscape">
	</cfcase>
	<cfcase value="Vertical">
		<cfset documentorientation = "Portrait">
	</cfcase>	
</cfswitch>

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

<cfif URL.Format eq "">	
	<cfset URL.Format = Entity.DefaultFormat>
</cfif>

<cfquery name="Org" 
 datasource="AppsOrganization">
 SELECT *
 FROM   Organization
 WHERE  OrgUnit = '#Action.OrgUnit#' 
</cfquery>

<cfset FileNo = round(Rand()*1000)>

<cfif URL.Format eq "FlashPaper">
	<cfset attach = "document#FileNo#.swf">
<cfelse>
    <cfset attach = "document#FileNo#.pdf">
</cfif>	

<cfoutput query="Action">

<cfif DocumentContent eq "">

	<cf_message message="There is nothing to print" return="close">
	<cfabort>

</cfif>

<cfif url.mode eq "pdf" and url.format neq "HTML">

	  <cfset text = replace("#DocumentContent#", "@pb", "<p style='page-break-after:always;'>&nbsp;</p>", "ALL")>	
	 
	  <cftry>		
		<cfdirectory action="CREATE" directory="#SESSION.rootDocumentPath#\CFRStage\User\#Session.acc#\">
		<cfcatch></cfcatch>
   	  </cftry>	 
	 
	  <cffile action="WRITE" 
	        file="#SESSION.rootDocumentPath#\CFRStage\User\#Session.acc#\#DocumentName#.htm" 
		    output="#text#" 
			addnewline="Yes" 
		    fixnewline="No">										 

	  <!--- NEW on-the-fly converter of htm content to pdf --->  
      <cf_htm_pdf fileIn="#SESSION.rootDocumentPath#\CFRStage\User\#Session.acc#\#DocumentName#">
		
 	  <cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	  <cfset mid = oSecurity.gethash()/>		
	  
	  <cfoutput>
		<script>		
			window.open('#SESSION.root#/CFRStage/getFile.cfm?File=#DocumentName#.pdf&mid=#mid#','_top')
		</script>
	  </cfoutput>		 

	<!--- this was the old Coldfusion embedded content which we replaced with a component 
	 
	<cfparam name="client.footer" default="">

    <!---
	<cfset text = replace("#DocumentContent#", "@pb", "<cfdocumentitem type = 'pagebreak'></cfdocumentitem>", "ALL")>
	--->
			
	<cfset text = replace("#DocumentContent#", "@pb", "<p style='page-break-after:always;'>&nbsp;</p>", "ALL")>
				
	<cfscript>
		matches = rematch("<footer>(.*)</footer>", text);
		results = "";
		for (match in matches){
			found = rereplace(match, "<footer>(.*)</footer>", "\1");
		    results = results & found; 
			text = replace (text,found,"","ALL"); 		
		}
	</cfscript>		

	<cfif DocumentFooter eq "">
		<cfset vDocumentFooter = results>
	<cfelse>
		<cfset vDocumentFooter = DocumentFooter>
	</cfif>
	
	<cfif vDocumentFooter neq "" and vDocumentmarginbottom lt 1.0>
		<cfset vDocumentmarginbottom = 1.0>
	</cfif>
								
	<cfdocument 
      format            = "#URL.Format#"
	  overwrite         = "yes"	  
      pagetype          = "#documentpagesize#"
	  orientation       = "#documentorientation#"
      unit              = "cm"
      encryption        = "none"
	  margintop         = "#vDocumentmargintop#"
      marginbottom      = "#vDocumentmarginbottom#"
      marginright       = "0"
      marginleft        = "0"
      fontembed         = "Yes"
      scale             = "#vDocumentscale#"
      backgroundvisible = "Yes">	
	  
		 #text#
		 									  
		<cfif DocumentHeader neq "">		
			<cfdocumentitem type="header">#DocumentHeader#</cfdocumentitem>						
		</cfif>  
		
		<cfif vDocumentFooter neq "">
			<cfdocumentitem type="footer">
			
				<cfif find("@default",vDocumentFooter)>	
				
				<table width="100%" style="height:10px">
				<tr class="labelmedium">
				<td style="font-size:13px" valign="bottom">#session.first# #session.last# #dateformat(now(),client.dateformatshow)# #timeformat(now(),"HH:MM")#</td>
				<td style="font-size:13px" valign="bottom" align="right"><cf_tl id="Page"> #cfdocument.currentpagenumber# <cf_tl id="of"> #cfdocument.totalpagecount#</td>
				</tr>
				</table>	
				
				<cfelse>
				#vDocumentFooter#
				</cfif>
			
			</cfdocumentitem>			
		</cfif>  		
										
	</cfdocument>
	
	--->
	
<cfelse>

	<!--- added for NY --->
	<!---
	<cfheader name="Content-Disposition" value="inline; filename=timeframe.doc" >
    <cfcontent type="application/word"> 	
	--->
	
	<link rel="stylesheet" type="text/css" href="#SESSION.root#/#client.style#">		
	<cfset text = replace("#DocumentContent#", "@pb", "<tr style='page-break-after: always;'></tr>", "ALL")>	
	<cfoutput>#Text#</cfoutput>
	
	<script>
	 window.print()
	</script>

</cfif>	

</cfoutput>
