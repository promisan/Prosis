<cfoutput>

<style>
	
	table.t_header{ 
		margin: 0; 
		padding: 0; 
		font: normal 12px arial, Helvetica, sans-serif; 
		width: auto; 
		color: ##FFFFFF; 
	}
	
	td.table_td {
		background: url(../img/FFFFFFtl.gif) repeat;
	}
	
	td.table_navi {
		font: bold 10px verdana; 
		text-align: center; 
		vertical-align: middle;
		padding: 10px 0 0 4px; 
		border: 0 none; 
		margin: 2px;
		color: ##FFFFFF;
	}
	
	td.table_data {
		width: 20px; 
		height: 50px;
	}
	
	table.t_title { 
		font-weight: bold; 
		color: ##FFFFFF; 
		filter: Alpha(Opacity=100, FinishOpacity=40, Style=1, StartX=25, StartY=0, FinishX=100, FinishY=100); 
		width: 100%; 
		padding: 0px; 
		vertical-align: middle; 
		margin: 0px;
	}
	
	table.t_title td.pagecorner { 
		background: url('#SESSION.root#/images/right_t.png') no-repeat right top;
		width: 20px; 
		height: 50px;
	}
	
	table.t_title td.pagecorner1 { 
		background: url('#SESSION.root#/images/FFFFFFpl.gif') no-repeat left top; 
		width:5pt; 
		height:15pt
	}
	
	a.a_t_header:hover {  
		font: bold 10px verdana; 
		color: ##00000; 
		text-decoration: none;
	}
	
	a.a_t_header{  
		font: bold 10px Verdana; 
		color: ##5a7590; 
		text-align: center; 
		vertical-align: middle; 
		filter: Light;
	}
	
	A.a_t_header:link {
		COLOR: ##00000; TEXT-DECORATION: none
	}
	
	
	a.a_t_header : active{  
		color: ##FFFFF; 
		text-align: center; 
	
	}
	
	td.title_class {  
		font: bold 10px Verdana; 
		color: ##FFFFF; 
		text-align: center; 
		vertical-align: middle; 
		filter: Light;
	}
	
</style>

<script>	
	
	function mainmenuselect(opt) { 
	      var count=0;
		  var se  = document.getElementsByName('opt')	  	
		  while (se[count]) {    
		    se[count].className = "menuregular" 
		    count++;
		  }	
	      opt.className = "menuselected"	    
	}
	
	function criteria(searchid,total,col,ds,d,t,w,o,c) {		
		ColdFusion.navigate ('CaseFile/AdvancedSearchCriteria.cfm?searchid='+searchid+'&ds='+ds+'&db='+d+'&Table='+ t +'&mode=new&where='+ w + '&layout='+o+'&class='+c ,'dcriteria');
	}
	
	function do_insert(c) {			  
		document.getElementById('fCriteria_'+c).onsubmit() 
		if( _CF_error_messages.length == 0 ) {
    	ColdFusion.navigate ('CaseFile/AdvancedSearchOperatorSubmit.cfm','dCriteria_'+c,'','','POST','fCriteria_'+c);
		}
	}
	
	function do_delete(searchid,l,c) {	
		ColdFusion.navigate ('CaseFile/AdvancedSearchDelete.cfm?class='+c+'&searchid='+searchid+'&line='+l,'getcontent');
	}
		
	function list_operators(m,searchid,ds,d,t,f,l,c,o,w) {
		ColdFusion.navigate ('CaseFile/AdvancedSearchOperator.cfm?searchid='+searchid+'&mode='+m+'&ds='+ds+'&db='+d+'&table='+t+'&Field='+f+'&layout='+l+'&class='+c+'&operator='+o+'&where='+w,'doperator_'+c);
	}
	
	function do_search(searchid,cat,tme) {
	    casetype = document.getElementById("CaseType");
	    caseclass = document.getElementById("CaseClass");
		ColdFusion.navigate ('SearchResult.cfm?searchid='+searchid+'&engine=advanced&category='+cat+'&time='+tme+'&casetype='+casetype.value+'&caseclass='+caseclass.value,'getcontent');
	}
		
	function showcrit(itm) {
		
		se = document.getElementById(itm) 
		ex = document.getElementById(itm+"_exp") 
		co = document.getElementById(itm+"_col") 
		
		if (se.className == "hide") {
		   se.className  = "regular"
		   ex.className  = "hide"
		   co.className  = "regular"
		} else {
		   se.className = "hide"
		   co.className  = "hide"
		   ex.className  = "regular"
		}
	}

</script>


</cfoutput>