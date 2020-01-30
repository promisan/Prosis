
<cfparam name="url.claimid"       default="">
<cfparam name="url.forclaimid"    default="">
<cfparam name="url.elementclass"  default="">
<cfparam name="url.drillid"       default="">
<cfparam name="url.elementid"     default="">
<cfparam name="url.mode"          default="Edit">

<cfif url.claimid neq "" and url.forclaimid eq "">
	<cfset url.forclaimid = url.claimid>
</cfif>

<cf_textareaScript>
<cf_listingscript>
<cf_dialogStaffing>   
<cf_dialogCaseFile>
<cf_pictureScript>

<head>   
    <!--- correction on the selection for CF ajax --->
    <script src="fixColdfusionAjax.js"></script>	
</head>

<!--- 
	  drillid might be:   ElementId     - when coming from ElementMatchedContent.cfm 
	  		              CaseElementId - when coming from other sources.
---->
<cfif url.drillid neq "">

	<cfquery name="drillKey" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   ClaimElement
		WHERE  CaseElementId = '#url.drillid#'
			   OR
			   ElementId	 = '#url.drillid#'
		
	</cfquery>
	
	<cfif drillKey.recordcount gt 0>
		<cfset url.caseelementid = drillKey.CaseElementId>	
		<cfset url.elementid	 = drillKey.ElementId>
	<cfelse>
		<cf_assignid>
	    <cfset url.caseelementid = rowguid>
	</cfif>
	
<cfelse>
	<cf_assignid>
    <cfset url.caseelementid = rowguid>
</cfif>	


<cfif url.elementid neq "">
	
	<cfquery name="thisElement" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 SELECT   *
	     FROM     Element			
		 WHERE    ElementId = '#url.elementid#'	
	</cfquery>
	
	<cfif thisElement.recordcount eq "0">
	
	<table align="center">
		<tr><td height="40"><font face="Verdana" color="FF0000"><cf_tl id="Sorry this element no longer exists"></font></td></tr>
	</table>
	
	<cfabort>	
	
	</cfif>	

</cfif>

<cfquery name="CaseElement" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT   *
     FROM     ClaimElement			
	 WHERE    CaseElementId = '#url.caseelementid#'	
</cfquery>

<cfif CaseElement.recordcount eq "1">

	  <!--- click on edit --->  
	  <cfif url.forclaimid eq "">    
	  	  <cfset url.forclaimid  = caseelement.claimid>		 	  		  
	  </cfif>
	  <cfset url.elementid   = caseelement.elementid>	  
				  
	  <cfquery name="Element" 
			datasource="AppsCaseFile" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			 SELECT   *
		     FROM     Element			
			 WHERE    ElementId = '#CaseElement.elementid#'				
	  </cfquery>	  
	  	   
	  <cfset url.elementclass = element.elementclass>
	  
<cfelse>

      <cfif url.elementid eq "">
	  
	  	  <cf_menuscript>
	
		  <cf_assignid>	
		  <cfset url.elementid = rowguid>
		  
		   <cfquery name="Element" 
				datasource="AppsCaseFile" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				 SELECT   *
			     FROM     Element			
				 WHERE    1=0			
		  </cfquery>	
		  		  		  
	  <cfelse>
	  	  
		   <cfquery name="Element" 
				datasource="AppsCaseFile" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				 SELECT   *
			     FROM     Element			
				 WHERE    ElementId = '#url.elementid#'			
		  </cfquery>	
		  		  
		  <!--- provision only should not occur --->
		  		  
		  <cfif url.forclaimid eq "">
			  
			  <cfquery name="getClaimElement" 
					datasource="AppsCaseFile" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					 SELECT   *
				     FROM     ClaimElement			
					 WHERE    ElementId = '#url.elementid#'				
			  </cfquery>	  
			 
			  <cfset url.forclaimid = getClaimElement.claimid>	
					  
		  </cfif>
		  
		  <!---- end of provision ------------ --->
		  
		  <cfset url.elementclass = element.elementclass>	  
		  
	  </cfif>	  
		  		  
</cfif>

<cfif url.forclaimid eq "">

	<table align="center">
		<tr><td height="60" class="labelit"><cf_tl id="This element is not associated to a CaseFile"></td></tr>
	</table>

	<cfabort>
	
</cfif>


<cfquery name="Class" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT   *
	     FROM     Ref_ElementClass 
		 WHERE    Code = '#url.elementclass#'				
</cfquery>


<!--- get the data from the case for this element --->

<cfquery name="Case" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   Claim.*, 
	         R.Description AS ClaimTypeDescription, 
			 C.Description AS ClaimTypeClassDescription
    FROM     Claim INNER JOIN
             Ref_ClaimType R ON Claim.ClaimType = R.Code INNER JOIN
             Ref_ClaimTypeClass C ON Claim.ClaimTypeClass = C.Code AND R.Code = C.ClaimType
	WHERE    ClaimId = '#url.forclaimid#'			
</cfquery>

<cfset url.mission = case.mission>

<cfquery name="getTopicList" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT    R.*
	     FROM      Ref_Topic R INNER JOIN Ref_TopicElementClass S ON R.Code = S.Code
		 WHERE     ElementClass = '#url.elementclass#'	
		 AND       Operational = 1
		 AND       R.TopicClass != 'Person'
		 AND       (Mission = '#url.Mission#' or Mission is NULL)	
		 ORDER BY  S.ListingOrder,R.ListingOrder 
</cfquery>

<cfoutput>

<cfif url.mode neq "view">
	<cfif url.elementclass eq "Person">
		
		<!---- Removed due to person custom shuffle
		<body onLoad="document.getElementById('LastName').focus()">
		--->
		
	<cfelse>
	
		<body onLoad="document.getElementById('Topic_#GetTopicList.Code#').focus()">
	
	</cfif>
</cfif>

</cfoutput>

<cfoutput>
	
	<script language="JavaScript">
	
		// check for matched records 
	    function retrievematched(id) {			 
			ptoken.navigate('ElementMatched.cfm?claimid=#forclaimid#&mission=#url.mission#&elementclass=#url.elementclass#&caseelementid='+id,'boxmatched','','','POST','elementform')		
		}
		
		function addmatched(id) {
		
		    try { 
  				 ColdFusion.Window.destroy('addElements',true); 
			   } catch(e) {} 

			ColdFusion.Window.create('addElements', 'Add selected elements', '',{height:640,width:760,resizable:true,modal:true,center:true});			
    		ptoken.navigate('ElementMatchedConfirm.cfm?caseelementid='+id+'&claimid=#forclaimid#&elementclass=#url.elementclass#&elementid=#url.elementid#','addElements','','','POST','elementform')		
		}
	
		function validate(mde,id,elementid,force,actionid) {
		  
			document.elementform.onsubmit() 
			if( _CF_error_messages.length == 0 ) {    
			    if (elementid == '' || force == 1) {				 
				 ptoken.navigate('ElementSubmit.cfm?actionid='+actionid+'&mission=#case.mission#&drillid=#url.drillid#&submitmode='+mde+'&caseelementid='+id+'&forclaimid=#forclaimid#&elementclass=#url.elementclass#&elementid='+elementid,'contentbox1','','','POST','elementform')
				 } else {
				 ColdFusion.Window.create('dialogconfirm', 'Confirmation', '',{x:100,y:100,height:640,width:760,resizable:true,modal:true,center:true});								
				 ptoken.navigate('ElementSubmitConfirm.cfm?actionid='+actionid+'&mission=#case.mission#&drillid=#url.drillid#&submitmode='+mde+'&caseelementid='+id+'&forclaimid=#forclaimid#&elementclass=#url.elementclass#&elementid='+elementid,'dialogconfirm','','','POST','elementform')			
				 }			                 
			}   	
		}
		
		function elementmemo(fld) {		    
		    ColdFusion.Window.create('dialogmemo', 'Memo', '',{x:100,y:100,height:#client.height-200#,width:#client.width-300#,resizable:true,modal:true,center:true})
			ptoken.navigate('FieldCustomMemo.cfm?field='+fld,'dialogmemo','','','POST','elementform')			
		}
				
		function showclaim(id,id2)	{
		   ptoken.open("../../Case/CaseView/CaseView.cfm?claimId="+id+"&Mission="+id2,"_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes");
		}
		
		
		function openmap(field)	{		   	
		val = document.getElementById(field).value	
		try { ColdFusion.Window.destroy('mymap',true) } catch(e) {}
		ColdFusion.Window.create('mymap', 'Google Map', '',{x:100,y:100,height:580,width:440,modal:false,resizable:false,center:true})    							
		ptoken.navigate('#SESSION.root#/Tools/Maps/MapView.cfm?field='+field+'&coordinates='+val,'mymap') 					
        }
	
	   function refreshmap(field,ret) {			      	    
			document.getElementById(field).value = ret
			ptoken.navigate('#SESSION.root#/tools/maps/getAddress.cfm?coordinates='+ret,field)	
    	} 	
				
		function associate(id,elementclass,elementidfrom,mis,mode) {			
		
			ColdFusion.Window.create('mydialog', 'Association', '',{x:0,y:0,height:document.body.clientHeight-20,width:document.body.clientWidth-20,modal:true,resizable:false,center:true})    
			ColdFusion.Window.show('mydialog') 				
			ptoken.navigate('#SESSION.root#/CaseFile/Application/Element/Association/Association.cfm?mode='+mode+'&mission='+mis+'&elementid=' + elementidfrom + '&elementclass=' + elementclass,'mydialog') 	
		}
		
		function associaterefresh(mis,elementidfrom,elementclass,mode) {		      
			ptoken.navigate('../Association/AssociationListingDetail.cfm?mission='+mis+'&forclaimid=#forclaimid#&elementid=' + elementidfrom + '&elementclass=' + elementclass,mode+'_'+elementclass+'_ass')
		
		}
		
		function associateedit(thisform,elementfrom,elementto,box,elementclass,mis,relid,mode) {
				  			
			document.getElementById(thisform).onsubmit() 		
			if( _CF_error_messages.length == 0 ) {                     
				ptoken.navigate('../Association/AssociationAddSubmit.cfm?mission='+mis+'&scope=embed&elementidfrom='+elementfrom+'&elementclass='+elementclass+'&elementidto='+elementto+'&relationid='+relid+'&mode='+mode,mode+'_'+box,'','','POST',thisform)
			}
	    }
		
		function ShowCaseFileCandidate(personno){
		   w = #CLIENT.width# - 60;
	       h = #CLIENT.height# - 120;
	  	   ptoken.open("#SESSION.root#/Roster/Candidate/Details/PHPView.cfm?ID=" + personno + "&scope=casefile&mode=Manual", "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
		}
			
	</script>

</cfoutput>

<!--- location the element --->

<cfif url.mode neq "search">
		
	<cfquery name="TopicList" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 SELECT    R.*, S.PresentationMode
		     FROM      Ref_Topic R INNER JOIN Ref_TopicElementClass S ON R.Code = S.Code
			 WHERE     ElementClass = '#url.elementclass#'	
			 AND       Operational = 1		 
			 AND       S.PresentationMode = '6'	
			 AND       (Mission = '#url.Mission#' or Mission is NULL)		
			 ORDER BY  S.ListingOrder,R.ListingOrder
	</cfquery>		
			
	<cfquery name="getDetail" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT  DISTINCT E.ElementId,
			        E.Reference,    			
					
					<cfif url.elementclass eq "Person">
					
					    A.PersonNo,
						A.IndexNo,
						A.LastName,
						A.LastName2,
						A.FirstName,
						A.MiddleName,
						A.DOB,
						A.Gender,		
					
					</cfif>	
					
					<cfloop query="TopicList">			
						<cfset fld = replace(description," ","","ALL")>
						<cfset fld = replace(fld,".","","ALL")>
						<cfset fld = replace(fld,",","","ALL")>
						<cfset fld = replace(fld,"/","","ALL")>
						<cfset fld = replace(fld,"\","","ALL")>
							(SELECT TopicValue 
							 FROM   ElementTopic 
							 WHERE  ElementId = E.ElementId 
							 AND    Topic = '#code#') as #fld#,						
					</cfloop>	
									
				    E.Created		
						
			FROM    Element E 
			        INNER JOIN ClaimElement CE ON E.ElementId = CE.ElementId
					<cfif url.elementclass eq "Person">
					LEFT OUTER JOIN Applicant.dbo.Applicant A ON E.PersonNo = A.PersonNo
					</cfif>
		    WHERE   E.ElementId= '#url.elementid#' 		
					
		</cfquery>		
		
		<cfset label = "#class.description#: ">
		<cfset lbl = "0">
		
		<cfloop query="TopicList">

		    <cfif PresentationMode eq "6">
			
				<cfset fld = replace(description," ","","ALL")>
				<cfset fld = replace(fld,".","","ALL")>
				<cfset fld = replace(fld,",","","ALL")>
			
			    <cfset label = "#label# #evaluate('getDetail.#fld#')#">				
				<cfset lbl = "1">
				
			</cfif>
		
		</cfloop>	
		
		<cf_tl id="New" var="1">
			
		<cfif lbl eq "0">
			 <cfset label = "#class.description#">			
		</cfif>
						
		<cf_tl id="Maintain Case element" var="1">
		<cf_screentop height="100%" close="try {parent.ColdFusion.Window.hide('mydialog')}catch(e){window.close();}" scroll="Yes" bannerheight="50" layout="webapp" banner="gray" label="#label#" jquery="Yes">
		
</cfif>

<table width="97%" height="100%" cellspacing="0" cellpadding="0" align="center">

<tr><td height="10"></td></tr>

<cfif url.elementid eq "" or mode eq "view">

   <!--- nada --->

<cfelse>
		
	<tr><td colspan="2">
		<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
		
			<cfset ht = "48">
			<cfset wd = "48">
			
			<cfset itm = 1>
		
			<cf_tl id="Edit element" var="1">
		
		    <!--- show menu for different tabs for edit and/or association --->
	    	<cf_menutab item       = "#itm#" 
			            iconsrc    = "Logos/CaseFile/EditElement.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						class      = "highlight1"
						name       = "#lt_text#"
						source     = "">	
			
			<cfif url.elementclass eq "person" and Element.recordcount eq "1">
			
				<cfset itm = itm + 1>	
				
				<cf_tl id="Profile" var="1">
				
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Roster/Profile.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "2"
							name       = "#lt_text#"
							source     = "javascript:ShowCaseFileCandidate('#Element.personno#')">			
			
			</cfif>		
			
			<cfif class.enableAssociation eq "1">			
						
			<cfset itm = itm + 1>					
			
			<cf_tl id="Associations" var="1">
			
			<cf_menutab item       = "#itm#" 
			            iconsrc    = "Logos/CaseFile/Associate.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						targetitem = "2"
						name       = "#lt_text#"
						source     = "../Association/AssociationView.cfm?forclaimid=#url.forclaimid#&elementid=#url.elementid#&caseelementid=#url.drillid#">
						
			</cfif>		
			
			<cfset itm = itm + 1>					
			
			<cf_tl id="Memo" var="1">
			
			<cf_menutab item       = "#itm#" 
			            iconsrc    = "Logos/Program/Activity.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						targetitem = "2"
						name       = "#lt_text#"
						source     = "../Memo/MemoView.cfm?tabno=2&elementid=#url.elementid#&mission=#case.mission#">		
			

			<cfset itm = itm + 1>	
			
			<cf_tl id="Context" var="1">
			
			<cf_menutab item       = "#itm#" 
			            iconsrc    = "Logos/CaseFile/StarSchema.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						targetitem = "3"
						iframe     = "scope"
						name       = "#lt_text#"
						source     = "iframe:../View/ElementViewContext.cfm?elementid=#url.elementid#">

			<cfset itm = itm + 1>					
						
			<cf_tl id="Amendments" var="1">
			
			<cf_menutab item       = "#itm#" 
			            iconsrc    = "Logos/CaseFile/Reference.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						targetitem = "2"
						name       = "#lt_text#"
						source     = "ElementLog.cfm?tabno=#itm#&elementid=#url.elementid#&mission=#case.mission#">				
						
		
		</tr>
		</table>
	</td></tr>
	
	<tr><td colspan="2" class="linedotted"></td></tr>

</cfif>

<cfoutput>
	
	<cfinvoke component="Service.Access"  
    		 method="CaseFileManager" 
		     mission="#case.mission#" 
			 claimtype="#case.claimtype#"
		     returnvariable="access">
	
	<cfif access eq "READ" or access eq "EDIT" or access eq "ALL">
		    
		<tr><td height="4" colspan="2"></td></tr>
		<tr><td colspan="2" height="20">
			<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
			
			<cfloop query="Case">
			
				<tr><td class="labelit"><cf_tl id="CaseNo">:</td>
				    <td class="labelit"><b>#Case.DocumentNo#</b></td>
					<td class="labelit">Date:</td>
					<td class="labelit"><b>#dateformat(case.documentdate,CLIENT.DateFormatShow)#</b></td>			    
				    <td class="labelit"><cf_tl id="Case Type">:</td>
				    <td class="labelit"><b>#Case.ClaimTypeDescription#</td>
					<td class="labelit">Case:</td>
					<td class="labelit"><b>#Case.ClaimTypeClassDescription#</td>
			    </tr>
			
			</cfloop>
			
			</table>
		</td></tr>		
			
		
	<cfelse>
		<tr><td colspan="2" align="center"> <cf_tl id="Your profile does not allow you to view this record."> </td></tr>
	</cfif>
	
</cfoutput>

<cf_menuScript>
	
<cfif url.elementid eq "">

   <tr>
    <td valign = "top" colspan="2" id="contentbox1">
	   <cf_divscroll>
       <cfinclude template="ElementEditForm.cfm">
	   </cf_divscroll>
    </td>
   </tr>
   
<cfelse>

	<tr><td colspan="2" height="100%">

	<cf_divscroll>   
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">	
	
    <cf_menucontainer item="1" class="regular">			    
		<cfinclude template="ElementEditForm.cfm">		
	</cf_menucontainer>
	
	<cf_menucontainer item="2" class="hide">
	
	<cf_menucontainer item="3" class="hide" iframe="scope">
	
	</table>
	</cf_divscroll>
	</td>
	</tr>
	
<!--- custom fields entry --->

</cfif>
			
</table>

<cf_screenbottom layout="webapp">
