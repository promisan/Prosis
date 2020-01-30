<!--- show association if exisits or allow 
for entry of associate an item --->

<!---
<cfoutput>
FROM : #url.elementid#
To : #url.elementclass#
Added by Armin, url.drillid now correctly identifies each form and submit button.
</cfoutput>
--->

<cfparam name="url.mission" default="">
<cfparam name="url.show" 	default="children">
<cfparam name="url.mode" 	default="#url.show#">

<cfif url.mission eq "">
    <cfabort>
</cfif>

<cfquery name="ElementFrom" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
    FROM     Element
	WHERE    ElementId      = '#url.elementid#'						
</cfquery>

<cfquery name="Relationship" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
    FROM     ElementRelation
	WHERE    ElementId      = '#url.elementid#'						
	AND      ElementIdChild = '#url.drillid#'
</cfquery>

<cfif relationship.recordcount eq "0">
	
	<cfquery name="Relationship" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
	    FROM     ElementRelation
		WHERE    ElementIdChild = '#url.elementid#'						
		AND      ElementId      = '#url.drillid#'
	</cfquery>
	
	<cfif relationship.recordcount eq "0">
    	<cf_assignid>
	    <cfset assid = rowguid>	
		
	<cfelse>	
	
		<cfset assid = relationship.relationid>	
	</cfif>
	
<cfelse>

	<cfset assid = relationship.relationid>
	
</cfif>

<cfquery name="ElementTo" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
    FROM     Element
	WHERE    ElementId      = '#url.drillid#'						
</cfquery>

<cfoutput>

<cfform name="assform_#left(url.drillid,8)#" method="post" onsubmit="return false">

<cfif relationship.recordcount eq "0">

	<script>
		if(typeof updateSourceDocument == 'function') { 
			updateSourceDocument('0');
		}
	</script>

<table width="94%" align="right" cellspacing="0" cellpadding="0" class="formpadding">

<cfelse>

	<script>
		if(typeof updateSourceDocument == 'function') { 
			updateSourceDocument('#Relationship.RelationElementId#');
		}
		
	</script>

<table width="95%" align="right" cellspacing="0" cellpadding="0" class="formspacing">

</cfif>
			
		<cfquery name="getTopicList" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 SELECT    R.*
		     FROM      Ref_Topic R INNER JOIN Ref_TopicElementClass S ON R.Code = S.Code
			 WHERE     ElementClass = '#url.elementclass#'	
			 AND       Operational = 1
			 AND       TopicClass != 'Person' 
			 AND       (Mission = '#url.Mission#' or Mission is NULL)	
			 ORDER BY  S.ListingOrder,R.ListingOrder
		</cfquery>	

		<cfif relationship.recordcount eq "0">
						
		<tr><td width="100%" colspan="2">
		<table width="100%" align="center"><tr>
		       <cfset element  = url.drillid>	
			   <cfset personno = elementto.personno>			   		   	   
			   <cfinclude template="../Create/ElementViewCustom.cfm">		
		</tr></table>	   
		</td></tr>		
				
		</cfif>
	
	    <tr><td height="1" colspan="2" id="#url.show#_assbox_#left(url.drillid,8)#"></td></tr>

		<tr>
		<td width="10%" class="labelit"><cf_tl id="Type">:</td>
		<td width="90%">
		
			<cfquery name="Relation" 
					datasource="AppsCaseFile" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   *
				    FROM     Ref_ElementRelation R
					
					<cfif url.show eq "children">
					WHERE    R.ElementClassFrom   = '#elementfrom.elementclass#'			
					<!--- passed element from the loop --->
					AND      R.ElementClassTo     = '#url.elementclass#'
					<cfelse>
					WHERE    R.ElementClassFrom   = '#url.elementclass#'			
					<!--- passed element from the loop --->
					AND      R.ElementClassTo     = '#elementto.elementclass#'
					</cfif>
					ORDER By ListingOrder		
			</cfquery>
						
			<select name="RelationCode" class="regularxl">
				<cfloop query="relation">
					<option value="#Code#" <cfif relationship.relationcode eq code>selected</cfif>>#Description#</option>
				</cfloop>
			</select>
			
		</td>
		</tr>
		

		<cfif Relationship.RelationElementId neq ''>
		<tr><td colspan="2" height="5"></td></tr>
		<tr valign="top">
			<td width="10%" class="labelit"><cf_tl id="Source document">:</td>
			<td width="90%">
				<cfset url.key="#Relationship.RelationElementId#">
				<cfinclude template="../Create/ElementView.cfm">
			</td>
		</tr>
		<tr><td colspan="2" height="5"></td></tr>
		</cfif>
		
		<tr>
		
			<td colspan="2">
			    <textarea name="Memo" class="regular" style="padding:4px;font-size:12px;width:99%;height:100"
				onKeyUp="_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/tools/input/text/memolength.cfm?field=Memo&size=1000','memoass_#url.drillid#','','','POST','assform_#left(url.drillid,8)#')">#relationship.RelationMemo#</textarea>
				<cfif relationship.recordcount gt 0 >
					<input type="hidden" name="sourceId" value= "#relationship.RelationElementId#">
				</cfif>
			</td>
				
		</tr>
		
		<tr>
			<td align="right" style="padding-right:10px" colspan="2" id="memoass_#url.drillid#"></td>
		</tr>
		<tr><td colspan="2">
		
				<cfset insert="yes">
				<cfset remove="yes">
				
		        <cf_filelibraryN
					DocumentPath="CaseFileAssociation"
					SubDirectory="#assid#" 
					Filter = ""						
					Presentation="all"
					box="box_#assid#"
					Insert="#insert#"
					Remove="#remove#"
					loadscript="no"		
					width="100%"									
					border="1">	
	
		</td></tr>
		
		
		<tr><td colspan="2" class="line"></td></tr>
		<cfif relationship.relationcode neq "">
			<tr><td colspan="2" align="right" class="labelit">
				<font size="1" color="808080"><cf_tl id="Relationship recorded by"> #Relationship.OfficerFirstName# #Relationship.OfficerLastName# #dateformat(Relationship.created, CLIENT.DateFormatShow)# #timeformat(Relationship.created, "HH:MM")#</font>				
			</td></tr>
		</cfif>
		<tr><td colspan="2" align="center" class="labelit">
				
			<cfif relationship.relationcode eq "">
				
			     <cf_tl id="Add" var="1">		
			     <cfset lbl = "#lt_text#">
				 
			<cfelse>
			
			  <cf_tl id="Update" var="1">		  
			  <cfset lbl = "#lt_text#">
			  
			</cfif>
								
			<input type="button" 		
				onclick="associateedit('assform_#left(url.drillid,8)#','#url.elementid#','#url.drillid#','assbox_#left(url.drillid,8)#','#url.elementclass#','#url.mission#','#assid#','#url.show#','#url.mode#')" 
				value="#lbl#"    
				class="button10g" 
				style="width:170;height:23">			
		
			
		</td></tr>

</table>

</cfform>

		
</cfoutput>