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
<title>Print Result</title>

<cfquery name="Collection" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   *
FROM     Collection
WHERE    CollectionId = '#url.collectionid#' 
</cfquery>

<cfparam name="url.id"           default="">
<cfparam name="url.attachmentid" default="">
<cfparam name="url.elementclass" default="">
<cfparam name="url.mission"      default="#collection.mission#">
<cfparam name="url.mode"         default="case">
<cfparam name="url.presentation" default="full">

<cfif presentation eq "print">
  
  <cfoutput>
  <title>Print Result</title> 
  <link rel="stylesheet" type="text/css"  href="#SESSION.root#/#client.style#"> 		
  <link rel="stylesheet" type="text/css" href="#SESSION.root#/print.css" media="print">
  </cfoutput>
  
  <cfset action = "print">  
<cfelse>
  <cfset action = "open">   
</cfif>

<!--- ---------------------- --->
<!--- To log the user action --->
<!--- ---------------------- --->

<cfparam name="url.searchid" default = "">

<cfif url.searchid neq "" and url.searchid neq "undefined">

	<cf_assignid>
		
	<cfquery name="Logging" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO CollectionLogAction	(
					ActionId,
					SearchId,
					ActionTimeStamp,
					RecordKey,
					RecordClass, 
					OfficerAction,
					OfficerUserId, 
					OfficerLastName, 
					OfficerFirstName )
			VALUES (
				'#rowguid#',
				'#searchId#',
				getDate(),
				<cfif url.attachmentid neq ''>
					'#url.attachmentid#',
					'Document',
				<cfelseif url.id neq ''>
					'#url.id#',
					'Element',
				</cfif>
				'#action#',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#')  
	</cfquery>
	
</cfif>

<cfoutput>

<!--- <div class="standard"
     style="position: absolute; border: 1px solid silver; background-color: ffffff; width: 720px; height: #url.height-34#;overflow:auto">	 --->
	 	 		
<table width="100%" height="100%" style="position: absolute; border: 1px solid silver; background-color: ffffff; width: 720px; height: #url.height-34#;overflow:auto">

</cfoutput>
<!--- show menu options for the document --->

<cfset show = 0>

<cfif url.attachmentid neq "">
	
	<cfquery name="getAttachment" datasource="AppsSystem">
		SELECT * 
		FROM   Attachment
		WHERE  Attachmentid = '#url.attachmentid#'				
	</cfquery>
		
	<cfif getAttachment.recordcount eq 1>			
						
		<cfquery name="getClaim" datasource="AppsCaseFile">
		
			SELECT C.Mission, C.ClaimType 
			FROM   Claim C 
			INNER  JOIN ClaimElement CE ON C.ClaimId = CE.ClaimId
			INNER  JOIN Element E ON CE.ElementId = E.ElementId
			WHERE  E.ElementId = '#getAttachment.reference#'
			
			UNION 
						
			SELECT  C.Mission, C.ClaimType
			FROM    ElementRelation ER INNER JOIN
                    ClaimElement CE ON ER.ElementId = CE.ElementId INNER JOIN
                    Claim C ON CE.ClaimId = C.ClaimId
			WHERE   ER.RelationId = '#getAttachment.reference#'
					
		</cfquery>
				
		<cfloop query="getClaim">
					
			<cfinvoke component="Service.Access"  
    		 method="CaseFileManager" 
		     mission="#mission#" 
			 claimtype="#claimtype#"
		     returnvariable="access">
	
				<cfif access eq "READ" or access eq "EDIT" or access eq "ALL">
					<cfset show= show +1>
				</cfif>
			
		</cfloop>
		
		<cfif getClaim.recordcount eq "0">
		
			<cfoutput>
				<tr bgcolor="gray">
					<td align ="right">
						<img src="#SESSION.root#/images/close3.gif" alt="" border="0" onclick="document.getElementById('detail').className='hide'" style="cursor:pointer;">
					</td>
				</tr>
				<tr>
					<td align="center">
						<br><br>
						<cf_tl id="Document is no longer associated to a case/element.">
					</td>
				</tr>
			</cfoutput>
	
		<cfelseif show gt 0 >
		
		<tr bgcolor="gray">
		<td align="center">
		
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left" bordercolor="#C0C0C0">
			
				<cfoutput>		

				<tr>				
				<td style="padding-left:4px">			
				
				    <cfif url.presentation eq "print">
					<font size="3" color="FFFFFF">#SESSION.welcome# search</font>
					<cfelse>
					<table cellspacing="0" cellpadding="0" class="formpadding">
					<tr><td>					   																  
						<cfif url.presentation neq "full">						
							<cfoutput>							
							<a href="javascript:do_preview('#url.attachmentId#','1')"> <font size="2" color="FFFFFF">[Extended Preview]</font></a>																  
							</cfoutput>							
						</cfif>							
						</td>						
						<td>						
						<a href="javascript:get_file('#url.attachmentId#')"> <font size="2" color="FFFFFF">[Open Document]</font></a>								
						</td>						
						<td>						
						<a href="javascript:do_print('#url.searchid#','#url.attachmentId#','#url.id#')"> <font size="2" color="FFFFFF">[Print]</font></a>							
						</td>						
					</tr>
					</table>					
					</cfif>
					
				</td>
				
				<td align="right">
				 <font size="2" color="FFFFFF">
				#replace(getattachment.filename,"_","","one")# 
				</td>
								
				<td align="right" style="padding:3px">
				   <img src="#SESSION.root#/images/close3.gif" alt="" border="0" onclick="document.getElementById('detail').className='hide'" style="cursor:pointer;">
				</td>
				</tr>
				
				<tr><td class="line" colspan="4"></td></tr>
				
				</cfoutput>
				
								
				</table>
			
			</td>
		</tr>
		
		<cfelse>
		
			<cfoutput>
			<tr bgcolor="gray">
				<td align ="right">
					<img src="#SESSION.root#/images/close3.gif" alt="" border="0" onclick="document.getElementById('detail').className='hide'" style="cursor:pointer;">
				</td>
			</tr>
			<tr>
				<td align="center">
					<br><br>
					<cf_tl id="Your profile does not allow you to view this record.">
				</td>
			</tr>
			</cfoutput>
			
		</cfif>
		
	</cfif>
	
<cfelse>

<cfoutput>

	<tr><td align="right" style="padding:2px"> 
	   <img src="#SESSION.root#/images/close3.gif" alt="" border="0" onclick="document.getElementById('detail').className='hide'" style="cursor:pointer;">
	</td></tr>	

</cfoutput>

</cfif>

<tr><td height="100%" style="padding-left:10px;padding-right:10px;padding-bottom:10px;padding-top:5px;">

<cfif show gt 0 or  url.attachmentid eq ""> 

	<cfoutput>
	
	<iframe src="DocumentDetailContent.cfm?collectionid=#url.collectionid#&attachmentid=#url.attachmentid#&id=#url.id#&presentation=#url.presentation#" width="100%" height="100%" marginwidth="0" marginheight="0" frameborder="0">
	</iframe>

	</cfoutput>

</cfif>

</td></tr>

</table>

<!--- </div> --->

<script>
  document.getElementById('detail').className = "regular";
</script>


