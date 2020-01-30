


  <CFFUNCTION name="UtilizationGraph" returntype="void" output="Yes">  	
  <CFARGUMENT name="current" type="numeric" required="Yes">  	
  <CFARGUMENT name="total" type="numeric" required="Yes">  
  	<CFARGUMENT name="scaleto" type="numeric" required="No" default="100">  	
	<CFARGUMENT name="format" type="string" required="No" default="999999999.99">  
		<CFARGUMENT name="showfrom" type="boolean" required="No" default="yes">  	
		<CFPARAM name="REQUEST.cfcimgpath" default="images">  
			<CFIF ARGUMENTS.total>  		<CFSILENT><CFSET k=(ARGUMENTS.scaleto/ARGUMENTS.total)></CFSILENT>  	
				<TABLE cellspacing="0" border="0">  		
				<TR><TD><IMG src="#REQUEST.cfcimgpath#/appstyle/horbar2.gif" width="#int(evaluate(ARGUMENTS.current*k))#" height="12" border="0" 
				alt="#ARGUMENTS.current#%" 
				title="#ARGUMENTS.current#%"><IMG src="#REQUEST.cfcimgpath#/appstyle/horbar1.gif" width="#int(evaluate('(ARGUMENTS.total-ARGUMENTS.current)*k'))#" 
				height="12" border="0"></TD>  	
					<TD>                  <CFIF ARGUMENTS.format is "$">  			#dollarformat(ARGUMENTS.current)#<CFIF showfrom> from #dollarformat(ARGUMENTS.total)#      
				  </CFIF>                  <CFELSEIF ARGUMENTS.format is "%">  			#int(ARGUMENTS.current)#%                 
				   <CFELSE>  			#trim(numberformat(ARGUMENTS.current,"#ARGUMENTS.format#"))#
				   <CFIF showfrom> from #ARGUMENTS.total#</CFIF>                  </CFIF>                  </TD></TR>                 
				    </TABLE
