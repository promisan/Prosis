<cfparam name="url.checked"     default="">
<cfparam name="url.ItemPointer" default="">

<cfif url.checked neq "">

	<cfif url.checked eq "true">
	
		<cfquery name="Update" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
	    	INSERT INTO Ref_TopicEntryClass 
				(Code,
				 EntryClass,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,
				 Created)
			VALUES(
				'#url.topic#',
				'#url.class#',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#',
				getdate()
			)
			
		</cfquery>
		
	<cfelse>
	
		<cfquery name="Delete" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	DELETE FROM Ref_TopicEntryClass
			WHERE  Code       = '#url.topic#'
			AND    EntryClass = '#url.class#'
		</cfquery>
		
	</cfif>
	
</cfif>

<cfif url.ItemPointer neq "">

		<cfquery name="Update" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_TopicEntryClass
			SET    ItemPointer = '#url.ItemPointer#'
			WHERE  Code = '#url.topic#'	
			AND    EntryClass = '#url.class#'
		</cfquery>
		
</cfif>

<cfquery name="Select" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	
	SELECT C.Code, C.Description, EC.Code as Selected, EC.ItemPointer
	FROM   Purchase.dbo.Ref_EntryClass C
	LEFT   JOIN Ref_TopicEntryClass EC
		   ON C.Code = EC.EntryClass AND EC.Code = '#url.topic#'
	ORDER  BY C.ListingOrder

</cfquery>


<cfset columns = 4>
<cfset cont    = 0>

<cfoutput>

<table width="100%">

	<tr>  <td colspan="#columns#" height="15" align="center"> </td> </tr>
		
	<cfloop query="Select">
	
		<cfif cont eq 0> <tr> </cfif>
		<cfset cont = cont + 1>
		
		 <td bgcolor="<cfif selected neq "">ffffbf</cfif>">
		 	<input type="checkbox" value="#code#" <cfif Selected neq "">checked="yes"</cfif> onClick="javascript:ColdFusion.navigate('#SESSION.root#/Tools/Topic/Materials/EntryClass.cfm?Topic=#URL.Topic#&class=#code#&checked='+this.checked,'#url.topic#_entryclass')">
		 </td>
		<td bgcolor="<cfif selected neq "">ffffbf</cfif>" style="padding-left:3px; font-size:8pt;">#Description#
		</td>
		
		<td bgcolor="<cfif selected neq "">ffffbf</cfif>" style="padding-left:3px">
			<cfif Selected neq "">
				<select style="font-size : 7pt" onChange="javascript:ColdFusion.navigate('#SESSION.root#/Tools/Topic/Materials/EntryClass.cfm?Topic=#URL.Topic#&class=#code#&ItemPointer='+this.value,'#url.topic#_entryclass')">
					<option value="Class" <cfif ItemPointer eq "Class">selected</cfif> >Class</option>
					<option value="Color" <cfif itemPointer eq "Color">selected</cfif> >Color</option>
					<option value="UoM"   <cfif itemPointer eq "UoM"  >selected</cfif> >UoM</option>
				</select>
			</cfif>
		</td>
		 
		 <cfif cont eq columns> </tr> <tr> <td colspan="3" height="3px"></td></tr> <cfset cont = 0> </cfif>
		 
	 </cfloop>
	 
	 <tr class="hide">
	 	<td colspan="#columns#" height="25" align="center">  <cfif url.checked neq "">  <font color="##0080C0"> Saved! <font/> </cfif>  </td>
	 </tr>
	 
</table>

</cfoutput>
