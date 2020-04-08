<cfparam name="url.sortedby" default="Category">

<cfset client.fmission   = url.fmission>
<cfset client.programcode = url.programcode>
<cfset client.sortedby   = url.sortedby>



<cfswitch expression="#url.sortedby#">
	<cfcase value="Category">
		<cfset sort1 	 = "Category">
		<cfset sort1Desc = "CategoryDescription">
		<cfset sort1Show = 1>
		<cfset sort2 = "CategoryItemName">
		<cfset sort2Show = 1>
		<cfset sortQuery = "ItemClass, Category, CategoryItemName, ItemDescription">
	</cfcase>	
	<cfcase value="ItemDescription">
		<cfset sort1 	 = "ItemDescription">
		<cfset sort1Desc = "ItemDescription">
		<cfset sort1Show = 0>
		<cfset sort2 	 = "ItemDescription">
		<cfset sort2Show = 0>
		<cfset sortQuery = "ItemClass, ItemDescription">
	</cfcase>	
	<cfcase value="Classification">
		<cfset sort1 	 = "Classification">
		<cfset sort1Desc = "Classification">
		<cfset sort1Show = 0>
		<cfset sort2 	 = "Classification">
		<cfset sort2Show = 0>
		<cfset sortQuery = "ItemClass, Classification">
	</cfcase>	
</cfswitch>

<cfquery name="SearchResult" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM
			(
				SELECT 	I.*, 
						C.Description as CategoryDescription, 
						RC.CategoryItemName, 
						RC.CategoryItemOrder,
						P.ProgramName,
				
					    (SELECT count(*)
						 FROM   ItemTransaction 						 
						 WHERE  ItemNo = I.ItemNo
						 <cfif url.fmission neq "">
						 AND    Mission = '#url.fmission#' 
						 </cfif>) as InUse,
						 
						 (SELECT COUNT(*)
						 FROM   ItemUoM
						 WHERE  ItemNo = I.ItemNo) as UoMs,										
						 
						 <cfif url.fmission neq ""> 
							 
						    (SELECT  SUM(TransactionQuantityBase) 
							 FROM    ItemTransaction 
							 WHERE   Mission = '#url.fmission#'
							 AND     ItemNo = I.ItemNo ) as OnHand,
							 
							(SELECT  COUNT(*)
							 FROM    ItemUoMMission 
							 WHERE   ItemNo = I.ItemNo AND Mission = '#url.fmission#'
							 AND     Operational = 1) as Used, 
						 
						</cfif> 		 
						
						(SELECT COUNT(*)
						 FROM   Item 
						 WHERE  ParentItemNo = I.ItemNo) as Children
										 
						 
				FROM 	#CLIENT.LanPrefix#Item I 
				        INNER JOIN #CLIENT.LanPrefix#Ref_Category C ON I.Category = C.Category  
						INNER JOIN Ref_CategoryItem RC ON I.Category = RC.Category AND I.CategoryItem = RC.CategoryItem
						LEFT OUTER JOIN Program.dbo.Program P ON P.ProgramCode = I.ProgramCode
				WHERE	1 = 1
				<cfif client.search neq "">
					AND #PreserveSingleQuotes(client.search)# 
				</cfif>
				<!--- managed or used by this entity --->
				<cfif url.fmission neq "">
				AND		( I.Mission = '#url.fmission#' 
				          OR
						  I.ItemNo in (SELECT ItemNo 
							           FROM   ItemUoMMission 
									   WHERE  Mission = '#url.fmission#')	
					    )
				</cfif>
				<cfif url.used eq "1">
				AND EXISTS (SELECT 'X'
					    	FROM   ItemTransaction 						 
						    WHERE  ItemNo = I.ItemNo
						    <cfif url.fmission neq "">
						    AND    Mission = '#url.fmission#' 
						    </cfif>)
				</cfif>
				<cfif url.programcode neq "">
					AND I.ProgramCode = '#url.ProgramCode#'
				</cfif>	
			) SubQ
		ORDER BY #sortQuery# 
		
</cfquery>


<cfif url.fmission neq "">
	<cfset cols = 16>
<cfelse>	
	<cfset cols = 15>			
</cfif>
   
<table id="myListing" style="width:100%;" class="navigation_table" align="center">  

<tr><td class="line" colspan="<cfoutput>#cols#</cfoutput>"></td></tr> 

<tr class="fixrow labelmedium line">
	<td style="display:none;"></td>
    <td height="20" width="10"></td>
	<td width="10"></td>
	<td width="10"></td>
	<td><cf_tl id="Id"></td>
	<td></td>   
	<TD style="padding-right:3px"><cf_tl id="Description"></TD>
	<td style="padding-right:3px"><cf_tl id="Make"></td>
	<TD style="padding-right:3px"><cf_tl id="Classification"></TD>
	<TD style="padding-right:3px"><cf_tl id="Project"></TD>
	<TD style="padding-right:3px" align="center"><cf_tl id="Dest"></TD>
    <TD style="padding-right:3px"><cf_tl id="Value"></TD>
	<td style="padding-right:3px"><cf_tl id="In Use"></td>
	<td style="padding-right:3px" align="center"><cf_tl id="UoMs"></td>
	<td style="padding-right:3px"><cf_tl id="Child"></td>
	<cfif url.fmission neq "">
	<td align="right" style="padding-right:4px"><cf_tl id="On Hand"></td>	
	</cfif>
	<td align="right" style="padding-right:3px"><cf_tl id="Created"></td>
</tr>

<cfoutput query="SearchResult" group="ItemClass">
	
	<tr class="clsItemRow"><td height="20" colspan="#cols#" style="font-size:30px;height:45px" class="line labellarge">#ItemClass#</td></tr>	
	<cfoutput group="#sort1#">
		<cfif sort1Show eq 1>
			<tr class="clsItemRow">
				<td height="20" colspan="#cols#" style="color:6688aa;font-size:26px;height:45px" class="line labelmedium">
					#Evaluate("#sort1Desc#")#
				</td>
			</tr>	
		</cfif>
		<cfoutput group="#sort2#">
			<cfif CategoryItemName neq "default" and sort2Show eq 1>
				<tr class="clsItemRow">
				<td height="20" colspan="#cols#" class="line labelmedium" style="font-color:gray;height:45px;padding-left:6px">
					#Evaluate("#sort2#")#
				</td>
				</tr>	
			</cfif> 
		<cfoutput>
	
	<cfif operational eq "0">
		<cfset cl = "f4f4f4">
		<cfset it = "<i>">
	<cfelse>
	    <cfset cl = "ffffff">
		<cfset it = "">
	</cfif>
		
	<TR class="clsItemRow line navigation_row labelmedium" style="height:18px" bgcolor="#cl#">
	
		<td class="ccontent" style="display:none;">#CategoryDescription# #CategoryItemName# #itemNo# #ItemDescription# #make# #Classification#</td>
		<td width="10"></td>
		<td width="10"></td>
		<td align="center" width="5">#currentrow#.</td>		
		<td style="padding-left:6px;padding-top:2px">
		     <a class="navigation_action" href="javascript:recordedit('#ItemNo#', '#url.fmission#')">#it# #ItemNo#</a>
	    </td>		
		<td align="left" style="padding-top:0px;padding-left:4px;padding-right:4px" valign="middle">
		
		  <cfif url.fmission neq "">			
						
			 <cfif url.fmission neq "">
				<!--- nothing --->
				<cfset vColor = "">
				<cfset vMessage = "">
				<cfif url.fmission eq SearchResult.mission>
					<!--- blue --->
					<cfset vMessage = "Managed by " & url.fmission>
					<cfset vColor = "A8CEFD">
				</cfif>
				
				<cfif url.fmission eq SearchResult.mission and Used eq 1>
					<!--- orange --->
					<cfset vMessage = "Managed and Used by " & url.fmission>
					<cfset vColor = "FDCD86">
				</cfif>
				
				<table cellspacing="0" cellpadding="0">
					<tr>
					
						<cfif ItemClass eq "Asset">
							<td width="6" height="9" bgcolor="#vColor#" title="#vMessage#" style="border-color:808080;border-style:solid;border-width:1px;"></td>
						<cfelse>
							<td width="6" height="9" style="padding-top:2px;cursor:pointer;">
								<cf_img icon="edit" tooltip="#vmessage#" onclick="item('#ItemNo#','#url.fmission#','#url.idmenu#')">
							</td>
						</cfif>
						
					</tr>
				</table>
				
			 </cfif>			 
			 						  
		   <cfelse>
		   
		     <!---
		   	   	 <cf_img icon="edit" onclick="recordedit('#ItemNo#', '#url.fmission#');">			 
			 --->
		   
		   </cfif>
		 				  
		</td>				  
		
		<TD width="30%">#it##ItemDescription#</TD>
		<td>#it##Make#</td>
		<TD>#it##Classification#</TD>
		<TD>#it##ProgramName#</TD>
		<TD title="#Destination#" align="center">#it##ucase(mid(Destination,1,1))#</TD>
		<TD>#it##ValuationCode#</TD>
		<td align="center">#it#<cfif InUse eq "0"><font color="red">N</font><cfelse>Y</cfif></td>
		<td align="center">#it##lsNumberFormat(UoMs,',')#</td>
		<td align="center">#it##Children#</td>
		<cfif url.fmission neq "">
			<td align="right" style="padding-right:4px; <cfif onhand lt 0 and onhand neq "">color:FF0000; </cfif>">						
			#it#
				<cf_precision number="ItemPrecision">
				#lsNumberFormat(OnHand,pformat)#
			</td>
		</cfif>
		<td align="right" style="min-width:130px;padding-right:4px">#it##dateformat("#Created#",client.dateformatshow)# #timeformat("#Created#","HH:MM")#</td>
	</TR>
	
	</cfoutput>
	
	</cfoutput>
	
	</cfoutput>
	<tr class="clsItemRow"><td height="12" colspan="#cols#"></td></tr>
</cfoutput>

</TABLE>

<cfset AjaxOnLoad("doHighlight")>	

<script>
	Prosis.busy('no')
</script>