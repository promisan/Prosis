 
<!--- stock item --->

<cfquery name="Item" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Item
		WHERE 	ItemNo = '#URL.ID#'
</cfquery>

<cfquery name="ItemMaster" 
	datasource="appsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	ItemMaster
		WHERE 	Code = '#Item.ItemMaster#'
</cfquery>

<cfquery name="getTopics" 
	datasource="AppsMaterials"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT	 P.Description,P.SearchOrder, T.*
		FROM     Ref_Topic T INNER JOIN Ref_TopicEntryClass C ON T.Code = C.Code
					AND   C.EntryClass   = '#ItemMaster.EntryClass#'
					AND   T.Operational  = 1 
					AND   C.ItemPointer != 'UoM' <!--- reserved for ItemUoM --->
					AND   ValueClass IN ('List','Lookup')
					INNER JOIN Ref_TopicParent P ON T.Parent = P.Parent
		WHERE    T.TopicClass = 'EntryClass'	
		
		UNION 
		
		SELECT	 P.Description,P.SearchOrder,T.*
		FROM     Ref_Topic T INNER JOIN Ref_TopicCategory C ON T.Code = C.Code
					AND C.Category   = '#Item.Category#'
					AND T.Operational  = 1 					
					-- AND  ValueClass IN ('List','Lookup')
				 INNER JOIN Ref_TopicParent P ON T.Parent = P.Parent	
		WHERE    T.TopicClass = 'Category'		
		
				
		
		UNION 
		
		SELECT   P.Description,P.SearchOrder,T.*
		FROM     Ref_Topic T INNER JOIN Ref_TopicParent P ON T.Parent = P.Parent
		WHERE    T.TopicClass = 'Details'
		
		ORDER BY T.Parent, T.TopicClass, T.ValueClass, P.SearchOrder, P.Description, T.ListingOrder ASC
		
		
</cfquery>

<!---

UNION 
		
		SELECT	 P.Description,P.SearchOrder,T.*
		FROM     Ref_Topic T 
					-- AND  ValueClass IN ('List','Lookup')
				 INNER JOIN Ref_TopicParent P ON T.Parent = P.Parent	
		WHERE    T.TopicClass = 'ItemUoM'	
		
		--->

<cfquery name="Cls" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ItemClass
	WHERE 	Code = '#Item.ItemClass#'
</cfquery>
 
<cfform name="frmTopics" onsubmit="return false" id="frmTopics">
 
<table width="95%" border="0" align="center" class="formpadding">

 	<tr><td height="5"></td></tr>
	
	<cfoutput>
	
	<TR class="labelmedium2">
    <td width="140"><cf_tl id="Class">:</td>
    <TD colspan="4">#Cls.Description#
    </td>
    </tr>
	
	<cfif item.Classification neq "">
	    <TR class="labelmedium2">
		    <TD><cf_tl id="Code">:</TD>
		    <TD colspan="4">#item.Classification#</TD>
		</TR>
	</cfif>
	
	<!---
	<TR class="labelmedium2">
    <TD><cf_tl id="Description">:</TD>
    <TD>#item.ItemDescription#</TD>
	</TR>
	--->	
	
	
	<tr class="labelmedium2 line">
	<td colspan="6" height="40">
	<cf_tl id="Only change if you are absolutely certain on the effect this might have" class="message">
	<cf_tl id="for item price and stock management" class="message">		
	</td></tr>
	
	</cfoutput>
	
	<cfif getTopics.recordCount eq 0>
		<tr><td height="30" align="center" colspan="6"><font face="Calibri" size="2"><i>
			<cf_tl id="No topics recorded for this item" class="message">.<br><cf_tl id="Please check the Procurement Item Master for this Item" class="message">.
			</b></i></td></tr>
		<cfabort>
	</cfif>
	
	<cfoutput query="getTopics" group="Parent">
	
		<tr class="line">
			<td colspan="6" style="font-size:22px" class="labelmedium2">#Description#</td>			
		</tr>	
		
		<cfoutput group="ValueClass">
		
		<cfset cnt = 0>
	
		    <cfoutput>
			
			<cfset cnt = cnt+1>
	
			<cfif cnt eq "1"><tr></cfif>  
			
				<cfif TopicClass eq "Details">
				    <cfset tbch = "ItemTopic">
					<cfset tbcl = "ItemTopicValue">					
				<cfelse>
					<cfset tbch = "ItemClassification">
					<cfset tbcl = "ItemClassification">
				</cfif>  
			
				<td style="border:1px solid silver;max-width:230px;width:200px;padding-left:3px" class="fixlength labelmedium2">#TopicLabel#: <cfif ValueObligatory eq "1"><font color="ff0000">*</font></cfif></td>
				
				<cfquery name="GetHeader" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    	SELECT	*
							FROM 	#tbch# 
							WHERE 	ItemNo = '#URL.ID#'
							AND     Topic   = '#Code#'  								
				</cfquery>
				
				<td style="border:1px solid silver;max-width:30px;width:30px"><input type="checkbox" class="radiol" name="Topic_#Code#_Oper" ID="Topic_#Code#_Oper" value="1" <cfif getHeader.Operational eq "1">checked</cfif>></td>
								
				<cfif valueclass eq "Text">
											
				<td colspan="4" style="width:40%;border:1px solid silver;padding-left:4px">
				
				<cfelse>
				
				<td style="width:40%;border:1px solid silver;padding-left:4px">
				
				</cfif>
									
					<cfif ValueClass eq "List">
					
						<cfquery name="GetList" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT	T.*, 
										P.ListCode as Selected
								FROM 	Ref_TopicList T 
										LEFT OUTER JOIN #tbcl# P ON P.Topic = T.Code AND P.ItemNo = '#Item.ItemNo#'
								WHERE 	T.Code = '#Code#'  
								AND 	T.Operational = 1
								ORDER BY T.ListOrder ASC
						</cfquery>
						
						<select class="regularxxl" name="Topic_#Code#" ID="Topic_#Code#">
							<cfif ValueObligatory eq "0">
								<option value=""></option>
							</cfif>
							<cfloop query="GetList">
								<option value="#GetList.ListCode#" <cfif GetList.Selected eq GetList.ListCode>selected</cfif>>#GetList.ListValue#</option>
							</cfloop>
						</select> 
						
					<cfelseif ValueClass eq "Lookup">
					
						<cfquery name="GetList" 
							  datasource="#ListDataSource#" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
						
								 SELECT     DISTINCT 
								            #ListPK# as ListCode, 
								            #ListDisplay# as ListValue,
										    #ListOrder# as ListOrder,
										    P.Value as Selected
								  FROM      #ListTable# T LEFT OUTER JOIN 
										   	(SELECT ItemNo, Topic, ListCode As Value 
											 FROM   Materials.dbo.#tbcl# 
											 WHERE  ItemNo='#Item.ItemNo#') P ON P.Topic = '#GetTopics.Code#' 
								  WHERE     #PreserveSingleQuotes(ListCondition)#
								  ORDER BY  #ListOrder#
						
						</cfquery>
							
						<select class="regularxxl" name="Topic_#Code#" ID="Topic_#Code#">
							<cfif ValueObligatory eq "0">
								<option value=""></option>
							</cfif>
							<cfloop query="GetList">
								<option value="#ListCode#" <cfif Selected eq ListCode>selected</cfif>>#ListValue#</option>
							</cfloop>
						</select> 	
						   
					<cfelseif ValueClass eq "Text">
				
							 <cfquery name="GetValue"  
							  datasource="appsMaterials" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
								  SELECT *
								  FROM   #tbcl#
								  WHERE  Topic  = '#Code#'		
								  AND    ItemNo = '#Item.ItemNo#'				 
							</cfquery>							
							
							<cfinput type = "Text"
						       name       = "Topic_#Code#"
						       required   = "#ValueObligatory#"					     
						       size       = "#valueLength#"
							   class      = "regularxxl enterastab"
							   message    = "Please enter a #Description#"
							   value      = "#GetValue.TopicValue#"
						       maxlength  = "#ValueLength#">   		
							   
					  <cfelseif ValueClass eq "Numeric">
				
							 <cfquery name="GetValue"  
							  datasource="appsMaterials" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
								  SELECT *
								  FROM   #tbcl#
								  WHERE  Topic  = '#Code#'		
								  AND    ItemNo = '#Item.ItemNo#'				 
							</cfquery>							
							
							<cfinput type = "Text"
						       name       = "Topic_#Code#"
						       required   = "#ValueObligatory#"					     
						       size       = "#valueLength#"
							   validate   = "float"
							   class      = "regularxxl enterastab"
							   message    = "Please enter a #Description#"
							   value      = "#GetValue.TopicValue#"
						       maxlength  = "#ValueLength#">   				   
					    
					</cfif>
									
				</td>
				
				<cfif valueclass eq "Text">
				</tr>
				<cfelse>
				<cfif cnt eq "2"></tr><cfset cnt= 0></cfif>
				</cfif>
					
		    	</cfoutput>
		
		</cfoutput>

	</cfoutput>
		
		<tr><td height="5"></td></tr>
		<tr><td colspan="4" class="line"></td></tr>
		<tr>
			<td colspan="2" style="padding-left:10px">
				<cf_tl id="Save" var="vSave">
				<input type="button" style="width:200px;height:29px" onclick="classificationvalidate()" value="<cfoutput>#vSave#</cfoutput>" id="save" class="button10g">
			</td>
		</tr>

</table>

</cfform>
  
