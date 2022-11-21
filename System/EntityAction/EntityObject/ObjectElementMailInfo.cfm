
<cfparam name="URL.MailBody" default="Script">

<cf_screentop height="100%" jquery="Yes" banner="gray" layout="webapp" label="#ucase(url.mailbody)# Mail Instructions" scroll="no">

<script>

	function toggleArea(divid){
	
		e = document.getElementById(divid);
		i1 = document.getElementById(divid+'_img_up');
		i2 = document.getElementById(divid+'_img_down');		
		if (e){
		
			if (e.className == 'regular'){
				e.className = 'hide';
			}else{
				e.className = 'regular';
			}			
		}	
		if (i1.className == 'regular'){
			i1.className = 'hide';
			i2.className = 'regular';
		}else{
			i1.className = 'regular';
			i2.className = 'hide';
		}		
	}
	
</script>

<cf_divscroll overflowy="scroll">

<cfif url.mailbody eq "custom">

	<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	<tr><td colspan="2" class="labelmedium2" style="padding-top:15px">
	You may use the following tags in the custom mail text :
	</td></tr>
		
	<tr><td colspan="2">
	
	<cfoutput>
	
	<table width="96%" class="navigation_table">
	<tr class="line navigation_row">
	<td style="width:100;padding:5px" class="labelmedium">@entity</td><td style="padding:3px" class="labelmedium">The name of the workflow object</td>	
	</tr>
	<tr class="line navigation_row">
	<td style="width:100;padding:5px" class="labelmedium">@class</td><td style="padding:3px" class="labelmedium">The class name of the workflow object</td>	
	</tr>
	<tr class="line navigation_row">
	<td style="width:100;padding:5px" class="labelmedium">@link</td><td style="padding:3px" class="labelmedium">A hyperlink to the workflow object for a user to open in the browser</td>	
	</tr>
	<tr class="line navigation_row">
	<td style="width:100;padding:5px" class="labelmedium">@person</td><td style="padding:3px" class="labelmedium">The first and last name of the person for which the object was created</td>	
	</tr>
	<tr class="line navigation_row">
	<td style="width:100;padding:5px" class="labelmedium">@candidate</td><td style="padding:3px" class="labelmedium">The first and last name of the candidate (person) for which the object was created</td>	
	</tr>
	<tr class="line navigation_row">
	<td style="width:100;padding:5px" class="labelmedium">@user</td><td style="padding:3px" class="labelmedium">The first and last name of the person triggering this mail</td>	
	</tr>
	<tr class="line navigation_row">
	<td style="width:100;padding:5px" class="labelmedium">@ref1</td><td style="padding:3px" class="labelmedium">The reference (1) of the workflow object</td>	
	</tr>
	<tr class="line navigation_row">
	<td style="width:100;padding:5px" class="labelmedium">@ref2</td><td style="padding:3px" class="labelmedium">The reference (2) of the workflow object</td>	
	</tr>
	<tr class="line navigation_row">
	<td style="width:100;padding:5px" class="labelmedium">@action</td><td style="padding:3px" class="labelmedium">The name of the action</td>	
	</tr>
	<tr class="line navigation_row">
	<td style="width:100;padding:5px" class="labelmedium">@mission</td><td style="padding:3px" class="labelmedium">The name of the entity processing the object</td>	
	</tr>
	<tr class="line navigation_row">
	<td style="width:100;padding:5px" class="labelmedium">@owner</td><td style="padding:3px" class="labelmedium">The owner of the track</td>	
	</tr>	
	<tr class="line navigation_row">
	<td style="width:100;padding:5px" class="labelmedium">@holder</td><td style="padding:3px" class="labelmedium">The last and first name of the user that initiated the workflow object</td>	
	</tr>
	<tr class="line navigation_row">
	<td style="width:100;padding:5px" class="labelmedium">@ipaddress</td><td style="padding:3px" class="labelmedium">The IP address of the user that initiated the workflow object</td>	
	</tr>
	<tr class="line navigation_row">
	<td style="width:100;padding:5px" class="labelmedium">@today</td><td style="padding:3px" class="labelmedium">The date (#CLIENT.DateFormatShow#) the mail was triggered</td>	
	</tr>
	<tr class="line navigation_row">
	<td style="width:100;padding:5px" class="labelmedium">@time</td><td style="padding:3px" class="labelmedium">The time (HH:MM) the mail was triggered</td>	
	</tr>
	</table>
	
	</cfoutput>
	
	</td></tr>

<cfelse>

	<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	<tr><td></td></tr>
	<tr>
		<td onclick="toggleArea('Instructions')" style="height:40px; cursor:pointer;" class="labellarge">
			<img src="<cfoutput>#SESSION.root#</cfoutput>/images/toggle_up.png" id="Instructions_img_up" class="regular" align="absmiddle">
			<img src="<cfoutput>#SESSION.root#</cfoutput>/images/toggle_down.png" id="Instructions_img_down" class="hide" align="absmiddle">
				Instructions
		</td>
	</tr>
	<tr>
		<td id="Instructions" class="hide">
		
		<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		<tr class="labelmedium"><td colspan="2">
		To develop a mail script file you must do the following :
		</td></tr>
		
		<tr class="labelmedium"><td width="20" valign="top" style="padding-top:2px">
		1.</td><td>Create a new cfm template in the /custom directory
		</td></tr>
		
		<tr><td></td></tr>
		
		<tr class="labelmedium"><td valign="top" style="padding-top:2px">
		2.</td><td>Prepare queries to extract your data in which you may use <b>Object.ObjectKeyValue4</b> to refer to your workflow object in your queries
		</td></tr>
		
		<tr><td></td><td class="labelit" style="padding:10px">Example :<br><br>
		
		<b>
		(cfquery name="Claim" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#")</b> <br>
			
			SELECT    * <br>
			FROM      #db#Claim C INNER JOIN #db#stPerson P ON C.PersonNo = P.PersonNo <br>
			WHERE     C.ClaimId = '#Object.ObjectKeyValue4#' <br>
		<b>	
		(/cfquery)
		</b>
				
		</td></tr>
		
		<tr class="labelmedium"><td>
		3. </td><td class="padding-left:0px">Declare the following optional CF variables :
		</td>
		</tr>
		
		<tr><td></td></tr>
		
		<tr style="padding-left:15px;height:20px" class="labelmedium"><td style="padding-left:25px;height:20px">
		a.	</td><td style="padding-left:10px">cfset <b>mailfrom</b> = "[mail from address]"
		</td>
		</tr>
		
		<tr style="padding-left:15px;height:20px" class="labelmedium"><td style="padding-left:25px;height:20px">
		b.	</td><td style="padding-left:10px">cfset <b>mailfromname</b> = "[mail from address name]"
		</td>
		</tr>
		
		<tr style="padding-left:15px;height:20px" class="labelmedium"><td style="padding-left:25px;height:20px">
		c.	</td><td style="padding-left:10px">cfset <b>mailto</b> = "[mail to address]"
		</td>
		</tr>
		
		<tr style="padding-left:15px;height:20px" class="labelmedium"><td style="padding-left:25px;height:20px">
		d.	</td><td style="padding-left:10px">cfset <b>mailcc</b> = "[mail cc address]"
		</td>
		</tr>
		
		<tr style="padding-left:15px;height:20px" class="labelmedium"><td style="padding-left:25px;height:20px">
		e.	</td><td style="padding-left:10px">cfset <b>mailbcc</b> = "[mail bcc address]"
		</td>
		</tr>
		
		<tr style="padding-left:15px;height:20px" class="labelmedium"><td style="padding-left:25px;height:20px">
		f.	</td><td style="padding-left:10px">cfset <b>mailsubject</b> = "[mail subject]"
		</td></tr>
		
		<tr style="padding-left:15px;height:20px" class="labelmedium"><td style="padding-left:25px;height:20px">
		g.	</td><td style="padding-left:10px">cfset <b>mailtext</b> = "[mail body]"
		</td></tr>
		
		<tr style="padding-left:15px;height:20px" class="labelmedium"><td style="padding-left:25px;height:20px">
		h.	</td><td style="padding-left:10px">cfset <b>mailatt</b> = "[attachments as an array mailatt[n][1] in full path]"
		</td></tr>
		
		<tr style="padding-left:15px;height:20px" class="labelmedium"><td style="padding-left:25px;height:20px">
		i.	</td><td style="padding-left:10px">cfset <b>disclaimer</b> = "Y/N include the signature block of the person sending the mail"
		</td></tr>
				
		<tr class="labelmedium"><td valign="top" style="padding-top:2px">
		4. </td><td>Declare the full script path/file to this mail object (Script Root) and test it! Scripted values are only read for fields determined as scripted in the config of this object.
		</td></tr>
		
		<tr><td height="4"></td></tr>
		
		</table>
			
	</td>
	</tr>
	
	<tr>
		<td onclick="toggleArea('Variables')"  style="height:40px; cursor:pointer;" class="labellarge">
			<img src="<cfoutput>#SESSION.root#</cfoutput>/images/toggle_up.png" id="Variables_img_up" class="regular" align="absmiddle">
			<img src="<cfoutput>#SESSION.root#</cfoutput>/images/toggle_down.png" id="Variables_img_down" class="hide" align="absmiddle">
				Variables
		</td>
	</tr>
	<tr><td id="Variables" class="hide">

		<table width="96%"  id="tlist" border="1" bordercolor="silver" align="center">
		
			<tr>
			<td style="width:100;padding:5px" class="labelmedium">#Object.ObjectKeyValue4#</td><td style="padding:3px" class="labelmedium">Key of the record being processed. Check General Settings > Master Table in the Worfklow.</td>	
			</tr>
			<tr>
			<td style="width:100;padding:5px" class="labelmedium">#Object.EntityDescription#</td><td style="padding:3px" class="labelmedium">The name of the workflow object</td>	
			</tr>
			<tr>
			<td style="width:100;padding:5px" class="labelmedium">#Object.EntityClassName#</td><td style="padding:3px" class="labelmedium">The class name of the workflow object</td>	
			</tr>
			<tr>
			<td style="width:100;padding:5px" class="labelmedium">#Object.ObjectURL#</td><td style="padding:3px" class="labelmedium">A hyperlink to the workflow object for a user to open in the browser</td>	
			</tr>
			<tr>
			<td style="width:100;padding:5px" class="labelmedium">#SESSION.first#</td><td style="padding:3px" class="labelmedium">The first name of the person triggering this mail</td>	
			</tr>
			<tr>
			<td style="width:100;padding:5px" class="labelmedium">#SESSION.last#</td><td style="padding:3px" class="labelmedium">The last name of the person triggering this mail</td>	
			</tr>
			<tr>
			<td style="width:100;padding:5px" class="labelmedium">#Object.ObjectReference#</td><td style="padding:3px" class="labelmedium">The reference (1) of the workflow object</td>	
			</tr>
			<tr>
			<td style="width:100;padding:5px" class="labelmedium">#Object.ObjectReference2#</td><td style="padding:3px" class="labelmedium">The reference (2) of the workflow object</td>	
			</tr>
			<tr>
			<td style="width:100;padding:5px" class="labelmedium">#Object.ActionDescription#</td><td style="padding:3px" class="labelmedium">The name of the action</td>	
			</tr>
			<tr>
			<td style="width:100;padding:5px" class="labelmedium">#Object.Mission#</td><td style="padding:3px" class="labelmedium">The name of the entity processing the object</td>	
			</tr>
			<tr>
			<td style="width:100;padding:5px" class="labelmedium">#Object.OfficerFirstName#</td><td style="padding:3px" class="labelmedium"> First name of the owner of the track</td>	
			</tr>	
			<tr>
			<td style="width:100;padding:5px" class="labelmedium">#Object.OfficerLastName#</td><td style="padding:3px" class="labelmedium"> Last name of the owner of the track</td>	
			</tr>	
			<tr>
			<td style="width:100;padding:5px" class="labelmedium">#Object.OfficerNodeIP#</td><td style="padding:3px" class="labelmedium">The IP address of the user that initiated the workflow object</td>	
			</tr>
			
		</table>
	
	
	</td>
	</tr>
	
	</table>
	
</cfif>	

</cf_divscroll>

<cf_screenbottom layout="webapp">
