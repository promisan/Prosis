
<head>
<cfoutput>
<script type="text/javascript">
  // Change cf's AJAX "loading" HTML
  _cf_loadingtexthtml="<div><img src=''/>";
</script>
</cfoutput>
</head>

<cfoutput>
<title>Visual</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />	
<link rel="stylesheet" type="text/css"  href="#SESSION.root#/#client.style#"> 		
<link rel="stylesheet" type="text/css" href="#SESSION.root#/print.css" media="print">
</cfoutput>

<cfparam name="Attributes.resolution"  default="40">
<cfparam name="Attributes.content"  default="">
<cfparam name="Attributes.module"  default="CaseFile">

<cfajaximport tags="cfdiv">

<script>
 function localdrag() {
   // no action 
 }

function SET_DHTMLS() {
	
	var d_a = arguments, d_ai, d_htm = '', d_o, d_i = d_a.length;
	while(d_i)
	{
		if(!(d_ai = d_a[--d_i]).indexOf('c:')) dd.cursor = d_ai.substring(2);
		else if(d_ai == NO_ALT) dd.noalt = 1;
		else if(d_ai == SCROLL) dd.scroll = 1;
		else if(d_ai == RESET_Z) dd.re_z = 1;
		else if(d_ai == RESIZABLE) dd.resizable = 1;
		else if(d_ai == SCALABLE) dd.scalable = 1;
		else if(d_ai == TRANSPARENT) dd.diaphan = 1;
		else
		{
			d_o = new DDObj(d_ai);
			dd.addElt(d_o);
			d_htm += d_o.t_htm || '';
			if(d_o.oimg && d_o.cpy_n)
			{
				for(var d_l = d_o.cpy_n, d_j = 0; d_j < d_l;)
				{
					var d_p = new DDObj(d_o.name+d_o.cmd, ++d_j);
					dd.addElt(d_p, d_o);
					d_p.defz = d_o.defz+d_j;
					d_p.original = d_o;
					d_htm += d_p.t_htm;
				}
			}
		}
	}
	
	dd.z = 0x33;	
	for(d_i = dd.elements.length; d_i;)
	{
		dd.addProps(d_o = dd.elements[--d_i]);
		if(d_o.is_image && !d_o.original && !d_o.clone)
			dd.n4? d_o.oimg.src = spacer : d_o.oimg.style.visibility = 'hidden';
	}
	dd.mkWzDom();
	if(window.onload) dd.loadFunc = window.onload;
	if(window.onunload) dd.uloadFunc = window.onunload;
	window.onload = dd.initz;
	window.onunload = dd.finlz;
	dd.setDwnHdl(PICK);
}
</script>

<cfoutput>
<script src="#SESSION.root#/Scripts/Drag/wz_dragdrop.js" type="text/javascript"></script>
</cfoutput>

<style type="text/css">
	
	body {
		background:#ffffff;
	}
	
	div.boxbase {
		background-color:gray;
		width:10px;
		height:10px;
		border: 1px #000 solid;
		padding-left:0px;
		padding-top:0px; 
		position: relative;
		left: 0px;
		top: 0px;
		z-index: 10;
	}
			
	div.cellstandard {
		background-color:transparent;	
		border: 0px #000 solid;
		position: absolute;
		left: 5px;
		cursor: pointer;	
		top: 5px;	
	}
	
	div.cellzoom {
		background:silver;
		width:100px;
		position: absolute;
		cursor: pointer;	
		left: 5px;
		top: 5px;	
	}
	
	div.highlighted{
		background-color:yellow;
		border: 0px #000 solid;
		position: absolute;
		left: 5px;
		cursor: pointer;	
		top: 5px;	
	}

</style>

<cfoutput>
		
	<table height="97%" width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="C0C0C0">	
	
	<cfset FileNo = round(Rand()*100)>
	<cfset dr = "">
	  
	<tr><td id="processme" class="hide"></td>
	<td colspan="#attributes.resolution#" height="10" class="noprint">
	
	<input type="button" name="Fill" ID="Fill" class="button10g" value="Clear" onclick="ColdFusion.navigate('#SESSION.root#/tools/activesheet/demo_clear.cfm','processme')" style="width:100">
	<input type="button" name="Fill" id="Fill" class="button10g" value="Print" onclick="window.print()" style="width:100">
	
	</td>
	</tr>
	
	<cfloop index="row" from="1" to="#attributes.resolution#">
	<tr>			
	<cfloop index="col" from="1" to="#attributes.resolution#">
	   
	    <td style="border:1px solid fafafa"> 			
		  <div style="position:relative" id="container_#row#_#col#">
		     <div style="position:absolute;" id="cell_#row#_#col#" class="standard"></div>
		  </div>					 
		</td>		
							
	</cfloop>		
	</tr>	
	</cfloop>
	</table>
	
	
</cfoutput>	

<cf_ActiveSheetContent resolution = "#attributes.resolution#" 
                       module="#attributes.module#" 
					   content="#attributes.content#">

</body>
</html>

