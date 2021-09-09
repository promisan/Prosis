
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
		SELECT	 T.*
		FROM     Ref_Topic T INNER JOIN Ref_TopicEntryClass C ON T.Code = C.Code
					AND C.EntryClass   = '#ItemMaster.EntryClass#'
					AND T.Operational  = 1 
					AND C.ItemPointer != 'UoM' <!--- reserved for ItemUoM --->
					AND  ValueClass IN ('List','Lookup')
		WHERE    T.TopicClass = 'EntryClass'	
		
		UNION 
		
		SELECT	 T.*
		FROM     Ref_Topic T INNER JOIN Ref_TopicCategory C ON T.Code = C.Code
					AND C.Category   = '#Item.Category#'
					AND T.Operational  = 1 					
					-- AND  ValueClass IN ('List','Lookup')
		WHERE    T.TopicClass = 'Category'					
		
		UNION 
		
		SELECT   T.*
		FROM     Ref_Topic T
		WHERE    T.TopicClass = 'Details'
		
		ORDER BY T.TopicClass, T.ListingOrder ASC
		
</cfquery>

<cfquery name="Cls" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ItemClass
	WHERE 	Code = '#Item.ItemClass#'
</cfquery>
 
<cfform name="frmTopics" onsubmit="return false" id="frmTopics">
 
<table width="95%" align="center" class="formpadding">

 	<tr><td height="5"></td></tr>
	
	<cfoutput>
	
	<TR class="labelmedium2">
    <td height="20" width="140"><cf_tl id="Class">:</td>
    <TD width="80%">#Cls.Description#
    </td>
    </tr>
	
    <TR class="labelmedium2">
    <TD height="20"><cf_tl id="Code">:</TD>
    <TD>#item.Classification#</TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD height="20"><cf_tl id="Description">:</TD>
    <TD>#item.ItemDescription#</TD>
	</TR>	
	
	<tr><td class="line" colspan="2" height="1"></td></tr>
	
	<tr class="labelmedium2">
	<td colspan="2" height="40" style="color:gray">
	<cf_tl id="Only change if you are absolutely certain on the effect this might have" class="message">
	<cf_tl id="for item price and stock management" class="message">		
	</td></tr>
	
	<tr><td class="line" colspan="2"></td></tr>
	
	<tr><td height="5"></td></tr>
	
	</cfoutput>
	
	<cfif getTopics.recordCount eq 0>
		<tr><td height="30" align="center" colspan="2"><font face="Calibri" size="2"><i>
			<cf_tl id="No topics recorded for this item" class="message">.<br><cf_tl id="Please check the Procurement Item Master for this Item" class="message">.
			</b></i></td></tr>
		<cfabort>
	</cfif>
	
	<cfoutput query="getTopics">

		<tr>
			<td width="80" height="23" class="labelmedium2">#TopicLabel#: <cfif ValueObligatory eq "1"><font color="ff0000">*</font></cfif></td>
			<td>
			
			    <cfif TopicClass eq "Details">
					<cfset tbcl = "ItemTopicValue">					
				<cfelse>
					<cfset tbcl = "ItemClassification">
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
				    
				</cfif>
								
			</td>
		</tr>

	</cfoutput>
		
		<tr><td height="5"></td></tr>
		<tr><td colspan="2" class="line"></td></tr>
		<tr>
			<td colspan="2" style="padding-left:10px">
				<cf_tl id="Save" var="vSave">
				<input type="button" style="width:200px;height:29px" onclick="classificationvalidate()" value="<cfoutput>#vSave#</cfoutput>" id="save" class="button10g">
			</td>
		</tr>

</table>

</cfform>
  
