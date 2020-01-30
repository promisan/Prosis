
<cf_screentop height="100%" close="parent.ColdFusion.Window.destroy('myprogram',true)" label="Program/Project select" banner="gray" jQuery="yes" scroll="Yes" layout="webapp">

<cfquery name="Parent" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Ref_AccountParent
</cfquery>

<cfparam name="URL.IDParent" default="">
<cfparam name="URL.Crit" default="">

<cfajaximport>
<cf_dialogREMProgram>
	
<CFOUTPUT>	
	
	<script>
	
	function reloadForm() {
	    	
		_cf_loadingtexthtml='';	
		crit = document.getElementById("find").value
		per  = document.getElementById("period").value	
		par  = document.getElementById("parent").value	
		url  = "ProgramSelectDetail.cfm?idparent="+par+
				"&crit="+crit+
				"&mission=#URL.mission#"+
				"&period="+per
		ColdFusion.navigate(url,'selection')				 
	}
	  
	function clearno() { document.getElementById("find").value = "" }
	
	function search() {
	
		 se = document.getElementById("find")	
		 if (window.event.keyCode == "13")
			{	document.getElementById("locate").click() }					
	    }
		
	function setvalue(prg) {
	    
    <cfif url.script neq "">
			
		try {
			parent.#url.script#(prg,'#url.scope#');	
		} catch(e) {}
	
    </cfif>	
	
	parent.ColdFusion.Window.destroy('myprogram',true);	
	
	}			
	
	function selected(acc,tpe,des) {
		se  = acc+";"+des+";"+tpe		
		if (se != "") {
			self.returnValue = se
		}
		else {
			self.returnValue = "blank"
		}
		self.close();
		}
	
	</script>
	
</CFOUTPUT>

<table width="100%" border="0" height="100%" style="padding-left:3px;padding-bottom:3px;padding-right:3px" cellspacing="0" cellpadding="0" align="center">

   <tr bgcolor="e4e4e4" class="line">

	  <td height="35">
	  
	  <table cellspacing="0" cellpadding="0">
	  
	  <tr>
	  <td style="padding-left:10px"></td>
	  
	  <td bgcolor="white">
	 
		 	<table style="padding:1px;border:1px solid silver;">
			
			<tr><td style="height:25px">
			
		 	 <cfoutput>
			 	  
			  <input type="text"
			       name="find" id="find"
			       size="26"
				   value=""			  
				   onClick="javascript:clearno()" onKeyUp="javascript:search()"
			       maxlength="25" 
				   style="border:0px;width:150px;padding-left:4px;font-size:14px">
			   
			   </td>
			   
			   <td style="padding:0px;border-left:0px solid Silver;">
			   
			    <img src="#SESSION.root#/Images/search.png" 
						  alt    = "Search" 
						  name   = "locate" id="locate"
						  onMouseOver= "document.locate.src='#SESSION.root#/Images/search.png'" 
						  onMouseOut = "document.locate.src='#SESSION.root#/Images/search.png'"
						  style  = "cursor: pointer;" 				 
						  border = "0" 
						  height="25" width="25"
						  align  = "absmiddle" 
						  onclick="reloadForm()">
				
			  </cfoutput>
			  
			  </td>
			  </tr>
			  </table>
		 </tr>
		  
	  </td>
	  </tr>
	  </table>
	  
	  </td>
  
	  <td class="labelmedium"><cf_tl id="Period">:</td>
	  
	  <td>
	  
	   <!--- match based on the validity of the position and we show by default the period of today --->
	  
	   <cfquery name="period" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   DISTINCT Period
			FROM     Program P INNER JOIN
		             ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode
			WHERE    P.Mission = '#URL.Mission#' 
			<cfif url.period neq "">		
			AND      (Pe.Period IN
		                     (SELECT   Period
		                      FROM     Organization.dbo.Ref_MissionPeriod
		                      WHERE    Mission = '#URL.Mission#' 
							  AND      (AccountPeriod = '#URL.Period#' or MandateNo = '#URL.Period#')) OR Pe.Period = '#URL.Period#')			  
			</cfif>			
			AND      Period IN (SELECT Period 
			                    FROM   Ref_Period 
								WHERE  DateEffective <= getDate()+300)
			ORDER BY Period		
	    </cfquery>
		
				
		<select name="period" id="period" class="regularxl" accesskey="P" title="Parent Selection" onChange="reloadForm(this.value)">
		<option value = "">All</option>
	    <cfoutput query="Period">
			<option value="#Period#" <cfif period eq period.period>selected</cfif>> #Period#</option>
		</cfoutput>
	    </select>
	      
	  </td>
	  
	  <td class="labelmedium"><cf_tl id="Class">:</td>
	  
	  <td align="right" style="padding-right:5px" class="labelmedium">
	  
	  <cfquery name="parent" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   DISTINCT ProgramClass
		FROM     Program P INNER JOIN
	             ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode
		WHERE    P.Mission = '#URL.Mission#' 
		<cfif url.period neq "">		
		AND (Pe.Period IN (SELECT   Period
	                       FROM     Organization.dbo.Ref_MissionPeriod
	                       WHERE    Mission = '#URL.Mission#' AND (AccountPeriod = '#URL.Period#' or MandateNo = '#URL.Period#')) OR Pe.Period = '#URL.Period#')			  
		</cfif>						
	    </cfquery>
		  
	    <select name="parent" id="parent"
		class="regularxl" accesskey="P" title="Parent Selection" onChange="javascript:reloadForm(this.value)">
		<option value = "">All</option>
	     <cfoutput query="Parent">
			<option value="#ProgramClass#">#ProgramClass#</option>
		</cfoutput>
	    </select>	
	  </td>
  
  </tr>
     
  <tr>
  
  <td height="100%" width="97%" align="center" style="padding-bottom:5px" valign="top" colspan="5">
  
  	<cf_divscroll>
  	    <table height="100%" width="100%">
		   <tr><td align="center" id="selection" style="padding:6px" valign="top"></td></tr>
		</table>
	</cf_divscroll>
       
	 <script>
	     reloadForm('')
	 </script>
		
  </td>
  </tr>
  
</table>

<cf_screenbottom layout="webapp">
