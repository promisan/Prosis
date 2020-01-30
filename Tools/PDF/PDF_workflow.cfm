
<cfoutput>

<cfparam name="Attributes.ObjectId" default="#URL.ObjectID#">
<cfparam name="Attributes.Memo" default="Yes">
<cfparam name="Attributes.LastDocument" default="No">
<cfparam name="Attributes.Launch" default="Yes">

<!--- cover page --->

<cfquery name="Cover" 
 datasource="AppsOrganization" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT   *
 FROM     OrganizationObject O INNER JOIN
          Ref_EntityClass R ON O.EntityCode = R.EntityCode AND O.EntityClass = R.EntityClass
 WHERE    ObjectId = '#Attributes.ObjectId#'
</cfquery>	

<cfquery name="Entity" 
 datasource="AppsOrganization" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT   *
 FROM     Ref_Entity
 WHERE    EntityCode = '#Cover.EntityCode#'
</cfquery>	

<cfdocument name="cfdoc"
          format="PDF"
          pagetype="letter"
          margintop="2"
          orientation="landscape"
          unit="in"
          encryption="none"
          fontembed="Yes"
          backgroundvisible="Yes"
          bookmark="True"
          localurl="No">
		  
	<cfdocumentsection name="#Cover.EntityClassName#">
	
	<cfdocumentitem type="footer">
		<table width="100%">
		<tr><td height="1" bgcolor="808080"></td></tr>
		<tr><td align="center">#Cover.ObjectReference#</td></tr></table>
	</cfdocumentitem>
	
	<table width="80%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		<tr><td colspan="2" align="center"><b><cf_tl id="CaseFile"></td></td></tr>
		<tr><td height="1" colspan="3" bgcolor="808080"></td></tr>
		<tr><td><b>Title</td><td>#Cover.EntityClassName#</td></tr>
		<tr><td><b>Reference</td><td>#Cover.ObjectReference#</td></tr>
		<tr><td></td><td>#Cover.ObjectReference2#</td></tr>
		<tr><td><b>Officer</td><td>#Cover.OfficerFirstName# #Cover.OfficerLastName#</td></tr>
		<tr><td height="1" colspan="3" bgcolor="808080"></td></tr>
	</table>
			
	</cfdocumentsection>	
	
</cfdocument>

<cfquery name="Step" 
 datasource="AppsOrganization" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT   P.ActionDescription,          
		  A.OfficerLastName, 
		  A.OfficerFirstName, 
		  A.OfficerDate, 
		  P.ActionSpecification
 FROM     OrganizationObjectAction A INNER JOIN
          Ref_EntityActionPublish P ON A.ActionPublishNo = P.ActionPublishNo AND A.ActionCode = P.ActionCode
 WHERE    A.ObjectId = '#Attributes.ObjectId#'
 ORDER BY A.ActionFlowOrder  
</cfquery>	

<cfdocument name="steps"
          format="PDF"
          pagetype="letter"
          orientation="landscape"
          unit="in"
          encryption="none"
          fontembed="Yes"
          scale="80"
          backgroundvisible="Yes"
          bookmark="True"
          localurl="No">

	<cfdocumentsection name="Actions Taken">
	
		<cfdocumentitem type="footer">
		
		<table width="100%" cellspacing="0" cellpadding="0">
		<tr><td height="1" bgcolor="808080"></td></tr>
		<tr><td align="center">#Cover.ObjectReference#</td></tr>
		</table>
		
		</cfdocumentitem>
	
		<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		<tr>
		   <td>Step</td>
		   <td>Officer</td>
		   <td>Date</td>
		</tr>
		<tr><td height="1" colspan="3" bgcolor="808080"></td></tr>
		<tr><td height="6"></td></tr>
		<cfloop query="step">
		<tr>
		   <td>#ActionDescription#</td>
		   <td>#OfficerFirstName# #OfficerLastName#</td>
		   <td>#dateformat(OfficerDate,CLIENT.DateFormatShow)# #timeformat(OfficerDate,"HH:MM")#</td>
		</tr>		
		</cfloop>	
		<tr><td height="1" colspan="3" bgcolor="808080"></td></tr>
		</table>	
	
	</cfdocumentsection>
		
</cfdocument>

<cfquery name="Document" 
 datasource="AppsOrganization" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT    Act.ObjectId, R.DocumentCode, R.DocumentDescription, R.DocumentOrder, Max(ActionFlowOrder) as ActionFlowOrder
	FROM      OrganizationObjectActionReport Doc INNER JOIN
              OrganizationObjectAction Act ON Doc.ActionId = Act.ActionId INNER JOIN
              Ref_EntityDocument R ON Doc.DocumentId = R.DocumentId
	WHERE     Act.ObjectId = '#Attributes.ObjectId#'
	GROUP BY Act.ObjectId, R.DocumentCode, R.DocumentDescription, R.DocumentOrder
	ORDER BY R.DocumentOrder
</cfquery>	

	<cfdocument name="embed"
          format="PDF"
          pagetype="letter"
          orientation="portrait"
          unit="in"
          encryption="none"
          fontembed="No"
          backgroundvisible="No"
          bookmark="yes"
          localurl="No">		
		  
	<cfdocumentsection name="Index">	  

	<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		<tr>
		   <td>No</td>
		   <td>Document</td>		 
		</tr>
		<tr><td height="1" colspan="3" bgcolor="808080"></td></tr>
		<tr><td height="6"></td></tr>
		<cfloop query="document">
		<tr>
		   <td>#DocumentOrder#</td>
		   <td>#DocumentDescription#</td>		   
		</tr>		
		</cfloop>	
		<tr><td height="1" colspan="3" bgcolor="808080"></td></tr>
	</table>	
	
	  <cfdocumentitem type="footer">
		
				<table width="100%" cellspacing="0" cellpadding="0">
				<tr><td height="1" bgcolor="808080"></td></tr>
				<tr><td align="center">#Cover.ObjectReference#</td></tr>
				</table>
		
	  </cfdocumentitem>
	
	</cfdocumentsection>
		
	</cfdocument>
		
	<cfloop query="document"> 
	
		<cfdocument name="doc#currentrow#"
          format="PDF"
          pagetype="letter"
          orientation="portrait"
          unit="in"
          encryption="none"
          fontembed="No"
          backgroundvisible="No"
          bookmark="yes"
          localurl="No">		  
		  
		  <cfquery name="Select" 
			 datasource="AppsOrganization" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				SELECT    *
				FROM      OrganizationObjectActionReport Doc INNER JOIN
			              OrganizationObjectAction Act ON Doc.ActionId = Act.ActionId INNER JOIN
                          Ref_EntityDocument R ON Doc.DocumentId = R.DocumentId
				WHERE     Act.ObjectId = '#ObjectId#'
				AND       Act.ActionFlowOrder = '#ActionFlowOrder#'
				AND       R.DocumentCode = '#DocumentCode#'	
			</cfquery>	
		  		 		
		  <cfdocumentsection name="#DocumentDescription#">
		  
			  <cfdocumentitem type="footer">
			
				<table width="100%" cellspacing="0" cellpadding="0">
				<tr><td height="1" bgcolor="808080"></td></tr>
				<tr><td align="center">#Cover.ObjectReference#</td></tr>
				</table>
			
				</cfdocumentitem>
																	  
	           #Select.DocumentContent# 
						
    	  </cfdocumentsection>		
		  
		
		</cfdocument>
		
	</cfloop>
	
	

	
<!--- pdf attachments --->

<!--- Use the cfpdf tag and cfpdfparam tags to merge individual PDF documents into a new PDF
document. Notice that the cfdoc variable created by using the cfdocument tag
is the source value of the first cfpdfparam tag. --->


<cftry>
<cfdirectory action="CREATE" directory="#SESSION.rootPath#\cfrstage\mergepdf\">
	<cfcatch></cfcatch>
</cftry>

 <cfdirectory action="LIST"
         directory="#SESSION.rootDocumentPath#\#Cover.EntityCode#\#URL.ObjectId#"
         name="Attachment"
         filter="*.pdf"
         sort="DateLastModified DESC"
         type="all"
         listinfo="all">
		
		<cfdocument name="att"
          format="PDF"
          pagetype="letter"
          orientation="portrait"
          unit="in"
          encryption="none"
          fontembed="Yes"
          backgroundvisible="Yes"
          bookmark="yes"
          localurl="No">
		  
		  <cfdocumentsection name="Annex">
		  
			   <cfdocumentitem type="header">
			
			    <table width="100%" cellspacing="0" cellpadding="0">
				<tr><td height="1" bgcolor="808080"></td></tr>
				<tr><td colspan="3" align="center">Annex</td></tr>
									
			   </cfdocumentitem>
			   
			   <cfdocumentitem type="footer">
			
						<table width="100%" cellspacing="0" cellpadding="0">
						<tr><td height="1" bgcolor="808080"></td></tr>
						<tr><td align="center">#Cover.ObjectReference#</td></tr>
						</table>
			
			   </cfdocumentitem>
		  
		   <table width="100%" cellspacing="0" cellpadding="0"> 
	        <cfloop query="Attachment">			
				<tr><td align="center">#Name#</td></tr>			 
			</cfloop>
		    </table>	
				
    	  </cfdocumentsection>	
		 		
		</cfdocument>
		
		
<!--- attachment merge --->

 <cfdirectory action="LIST"
             directory="#SESSION.rootDocumentPath#\#Cover.EntityCode#\#URL.ObjectId#"
             name="AttachFiles"            
             sort="DateLastModified DESC"
             type="all"
             listinfo="name">
			 
	<cfset go = 0>		 
			 
	<cfloop query="Attachfiles">
	 <cfif UCase(Right(name,4)) eq ".PDF" or
				 UCase(Right(name,4)) eq ".GIF" or 
			     UCase(Right(name,4)) eq ".JPG" or 
				 UCase(Right(name,4)) eq ".PNG">
	     <cfset go = 1>
	 </cfif>
	</cfloop>		 
			 
	<cfif go eq "1">		 

	     <cfpdf action="MERGE"
	          name         = "att2"
	          overwrite    = "Yes"
	          keepbookmark = "No">			  
			 		
		<cfloop query="AttachFiles">
		    
			<cfif UCase(Right(name,4)) eq ".PDF">
			
			  	<cfpdfparam source="#SESSION.rootDocumentPath#\#Cover.EntityCode#\#URL.ObjectId#\#Name#">			
			
			<cfelseif UCase(Right(name,4)) eq ".GIF" or 
			     UCase(Right(name,4)) eq ".JPG" or 
				 UCase(Right(name,4)) eq ".PNG">
						
				<cfdocument name="att#currentrow#"
			          format="PDF"
			          pagetype="letter"
			          margintop="0.0"
			          marginbottom="0.5"
			          marginright="0.1"
			          marginleft="0.1"
			          orientation="landscape"
			          unit="in"
			          encryption="none"
			          fontembed="Yes"
			          backgroundvisible="No"
			          bookmark="True">
			  
			  	  <cfdocumentsection name="Image:#Name#">
					 
					 <table width="100%" height="100%" cellspacing="0" cellpadding="0">
					 <tr><td height="15" align="left">#Name#</td></tr>
					 <tr><td height="1" bgcolor="silver"></td></tr>
					 <tr><td valign="top">
					 
					 <img src="#SESSION.rootDocument#/#Cover.EntityCode#/#URL.ObjectId#/#Name#"
					     alt=""			   
					     border="0">
					 
					 </td></tr>
					 </table>
				 
				  <cfdocumentitem type="footer">
		
					<table width="100%" cellspacing="0" cellpadding="0">
					<tr><td height="1" bgcolor="808080"></td></tr>
					<tr><td align="center">#Cover.ObjectReference#</td></tr>
					</table>
		
				   </cfdocumentitem>
				   
				 </cfdocumentsection>  
			  
				</cfdocument>
				
				<cfpdfparam source="att#currentrow#">	
				
										
			</cfif>	
		</cfloop>			
	
	</cfpdf>	

</cfif>	

		

<!--- final merge --->

<cfpdf action="MERGE"
          destination="#SESSION.rootPath#\cfrstage\mergepdf\#Attributes.ObjectId#.pdf"
          overwrite="Yes"
          keepbookmark="Yes">
		  
	<cfpdfparam source="cfdoc">
	
	<cfpdfparam source="steps">
	
	<cfpdfparam source="embed">
		
	<cfloop query="document"> 
		<cfpdfparam source="doc#currentrow#">
	</cfloop>
			
	<cfpdfparam source="att">
	
	<cfif attachfiles.recordcount gte "1">	
	   <cfpdfparam source="att2">
	</cfif>
	
			
</cfpdf>

<!--- attributes --->

<cfset PDFinfo=StructNew()>
<cfset PDFinfo.Title    = "#Cover.ObjectReference#">
<cfset PDFinfo.Author   = "#Cover.OfficerFirstName# #Cover.OfficerLastName#">
<cfset PDFinfo.Keywords = "Prosis,#SESSION.welcome#">
<cfset PDFinfo.Subject  = "#Cover.ObjectReference#">

<cfpdf action="setInfo" 
   source="#SESSION.rootPath#\cfrstage\mergepdf\#Attributes.ObjectId#.pdf" 
   info="#PDFinfo#" 
   destination="#SESSION.rootPath#\cfrstage\mergepdf\#Attributes.ObjectId#.pdf" 
   overwrite="yes">

<cfif attributes.launch eq "yes">

	<script>
		window.open("#SESSION.root#/cfrstage/mergepdf/#Attributes.ObjectId#.pdf","pdf")
	</script>

</cfif>

<a href="javascript:pdf_merge('#URL.ObjectId#')"><cf_tl id="CaseFile"></a>&nbsp;

</cfoutput>

