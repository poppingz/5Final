<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.6.0.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" ></script>
 <style>
     .container-fluid{width:1100px; margin-top: 60px; margin-bottom: 60px;}
     #menu{height: 430px;}
     #detailB{height: 50px;line-height: 50px;}
     #detailB>div{height: 100%;}
     #img{height:100%;}
     img{width:93%; height:100%;}
     .content{margin: 120px 0px 150px 0px;}
    #detailB>div{border:1px solid #ddd;}
     #detailT{border-bottom: 1px solid #ddd;}
     #detailT,#cmtT{font-size: 1.3em; font-weight: bold;}
     
     #infoBox{padding-left:8px; padding-top:3px;}
     #name{font-size: 1.2em; padding-left:8px;}
     #price{font-size: 1.8em;padding-left:8px; font-weight: bold; }
   	 .cmtBox{border-bottom: 1px solid #ddd; padding-bottom: 45px; margin: 20px 80px 0px 12px;}
     #content{resize: none; width: 97%; height: 95%; margin: 0px; padding: 8px; border:1px solid #ddd; border-radius:5px;}
     #cmtBtn{ width:75px; height:40px; margin:11px 0px 10px 0px; padding:8px 0px 0px 8px; border-radius:5px;
     		background-color:black; color:white; font-size:0.9em;}
     #cmtBtn:hover{cursor: pointer;}
     textarea{border:none; font-size:0.9em;}
     .col-3,.col-9{font-size: 0.9em;}
     .txt{background-color:#f6f6f6;font-size: 0.8em; text-align:center; width:70px; height:22px; margin-right:265px; padding: 2px 0px 0px 0px;}
     .ex{color:#949494; font-size: 0.8em; width:85px; padding: 2px 0px 0px 0px;}
     
     #funcBox{border-top: 1px solid #ddd; height: 60px; margin: 0px; }
     #funcBox>div{ height:100%; text-align: center; line-height: 40px;}
     #like{margin-right: 7px; width: 48%;}
     #chat{margin-left: 7px; width: 48%;  border:1px solid black;}
     #like,#chat:hover {cursor: pointer;}
     #like button{width:100%; height:100%;}
     
     #userBox{background-color:#F6F6F6;margin:48px 20px 0px 50px; width: 230px; height: 200px;}
     #userID{text-align:center; font-weight:600;}
     #repCount{margin-left:20px;width:50px;}
     #repCount span{font-weight:600; padding-left:5px;}
     #userID,#repCount,#repCount span:hover{cursor:pointer;}
     
     #crudBox{border: 1px solid #ddd;margin: 0px; padding-left:10px;}
     .ckT{font-size:20px; font-weight:600;}
     .ck{font-size:15px; font-weight:600; margin-top:10px;}
     .sold span{font-size:13px; margin-left:5px;}
     #update{border:1px solid #ddd; border-radius:10px; height:30px; margin:50px 10px 0px 20px; text-align:center; font-size:13px;}
     #delete{border:1px solid #ddd; border-radius:10px; height:30px; margin:4px 10px 0px 20px; text-align:center; font-size:13px;}
     
     .recmtBox{ border-bottom: 1px solid #ddd; padding-bottom: 15px; margin: 0px 80px 0px 12px; padding-top:10px;}
     .ID{font-weight:600; font-size:18px;}
     .ID span{margin-left:5px; font-weight:400; font-size:14px;}
     .cmt{width:930px; margin-bottom:15px;}
     .btnBox{text-align:right;}
     .del{margin-left:5px;}
 </style>
 <script>
 	$(function(){
 		
 		wishCount();
 		
 		$("#likeBtn").on("click",function(){
 			$.ajax({
 				url:"/rep/wishExist",
 				data:{"rep_id":$("#seq").val()}
 			}).done(function(resp){
 				console.log("resp : "+resp);
 				if(resp==1){
 					$.ajax({
 	 	  		   		url:"/rep/wishCancel",
 	 	  		   		data:{"rep_seq":$("#seq").val()}
 	 	  		   	}).done(function(){
 	 	  		   		alert("찜하기취소");
 	 	  		   		wishCount();
 	 	  		   	})
 	  		   }else{
 	  				$.ajax({
	 	  		   		url:"/rep/wishInsert",
	 	  		   		data:{"rep_id":$("#seq").val()}
	 	  		   	}).done(function(){
	 	  		   		alert("찜하기완료");
	 	  		   		wishCount();
		 	  		})
 	  		   } 
 			
 			})
 			
 			
 		})
 		
 		$("#userID").on("click",function(){
 			location.href="/rep/myJG?id="+$(this).text();
 		})
 		

 		$("#cmtBtn").on("click",function(){
 				$.ajax({
					url:"/recmt/insertProc",
					data:{"recmt_rep_seq":$("#seq").val(),"recmt_comments":$("#content").val()},
					dataType:"json"
				}).done(function(resp){
					$("#content").val("");
					console.log(resp);
					let recmtBox = $("<div class='row recmtBox'>");
					recmtBox.attr("seq",resp.recmt_seq); 
					
					let row1 = $("<div class='row m-0'>");
					let cmtID = $("<div class='col-5 p-0 ID'>");
					cmtID.text(resp.recmt_writer);
					let span = $("<span>");
					span.text(resp.recmt_write_date);
					
					let row2 = $("<div class='row m-0'>");
					let cmt = $("<div class='col-12 p-0 cmt'>");
					cmt.text(resp.recmt_comments);
					
					let row3 = $("<div class='row m-0'>");
					let col = $("<div class='col-12 p-0 btnBox'>");
					let modi = $("<input type='button' class='modi'>");
					modi.val("수정");
					let del = $("<input type='button' class='del'>");
					del.val("삭제");
					let hidden = $("<input type='hidden' class='recmt_seq'>");
					hidden.val(resp.recmt_seq);
					
					cmtID.append(span);
					row1.append(cmtID);
					row2.append(cmt);
					col.append(modi);
					col.append(del);
					col.append(hidden);
					row3.append(col);
					
					recmtBox.append(row1);
					recmtBox.append(row2);
					recmtBox.append(row3);
					
					$(".box").prepend(recmtBox);
				}) 
 		})
 		
 		$(document).on("click",".modi",function(){
 			let cmt = $(this).parents(".recmtBox").find(".cmt").text();
 			
 			if($(this).val()=="수정"){
 				$(".cmt").attr("contenteditable","false");
 	 			$(".modi").val("수정");
 	 			$(".del").val("삭제");
 				
 				$(this).parents(".recmtBox").find(".cmt").attr("contenteditable","true");
 	 			$(this).parents(".recmtBox").find(".cmt").focus();
 	 			
 	 			$(this).val("완료");
 	 			$(this).siblings(".del").val("취소");
 	 			$(this).siblings(".del").attr("content",cmt);
 	 			
 	 			
 			}else{
 				console.log("AAA");
 				$.ajax({
		 			url:"/recmt/update",
					data:{"recmt_comments":$(this).parents(".recmtBox").find(".cmt").text(),"recmt_seq":$(this).siblings(".recmt_seq").val()}
					}).done(function(){
						console.log("삭제완료");
						
					})
 			}
 			
 			
		})
		$(document).on("click",".del",function(){
			
			if($(this).val()=="삭제"){
				let result = confirm("댓글을 삭제하시겠습니까?")
				if(result){
					$.ajax({
			 			url:"/recmt/delete",
						data:{"recmt_seq":$(this).siblings(".recmt_seq").val()}
						}).done(function(resp){
							console.log(resp);
							$("<div>").removeAttr("")
							
						})
				}	
			}else{
				console.log($(this).attr("content"))
				$(".box").text("");
				getCmtList();
			}
			
		})
 		
		function wishCount(){
 			$.ajax({
				url:"/rep/wishCount",
				data:{"rep_seq":$("#seq").val()}
			}).done(function(resp){
				console.log(resp);
				$("#count").text(resp);
			})
 		}
 		
		function getCmtList(){
 			$.ajax({
 	 			url:"/recmt/list",
 				data:{"rep_seq":$("#seq").val()},
 				dataType:"json"
 				}).done(function(resp){
 					console.log(resp);
 					for(let i=0; i<resp.length;i++){
 						let recmtBox = $("<div class='row recmtBox'>");
 						
 						let row1 = $("<div class='row m-0'>");
 						let cmtID = $("<div class='col-5 p-0 ID'>");
 						cmtID.text(resp[i].recmt_writer);
 						let span = $("<span>");
 						span.text(resp[i].recmt_write_date);
 						
 						let row2 = $("<div class='row m-0'>");
 						let cmt = $("<div class='col-12 p-0 cmt'>");
 						cmt.text(resp[i].recmt_comments);
 						
 						let row3 = $("<div class='row m-0'>");
 						let col = $("<div class='col-12 p-0 btnBox'>");
 						let modi = $("<input type='button' class='modi'>");
 						modi.val("수정");
 						let del = $("<input type='button' class='del'>");
 						del.val("삭제");
 						let hidden = $("<input type='hidden' class='recmt_seq'>");
 						hidden.val(resp[i].recmt_seq);
 						
 						cmtID.append(span);
 						row1.append(cmtID);
 						row2.append(cmt);
 						col.append(modi);
 						col.append(del);
 						col.append(hidden);
 						row3.append(col);
 						
 						recmtBox.append(row1);
 						recmtBox.append(row2);
 						recmtBox.append(row3);
 						
 						$(".box").append(recmtBox);
 					}
 				})
 		}
		
 	})
 </script>
</head>
<body>
	<c:choose>
		<c:when test="${id==dto.rep_writer }">
			 <div class="container-fluid">
        <div class="row m-0" id=menu>
            <div class="col-6 p-0" id=img>
            	<img src="/img/${pdto.reSysName }">
            </div>
            <div class="col-5 " id=infoBox>
            	<div class="row m-0 mb-4">
            		<div class="col-2 txt">개인중고</div>
            		<div class="col-2 ex">${dto.rep_diff_date} ·찜<span id=count></span></div>
            	</div>
            	
                <div class="row m-0">
                    <div class="col-12 p-0 pb-1" id=name>${dto.rep_name}</div>
                </div>
                <div class="row m-0" id=priceBox>
                    <div class="col-12 p-0 pb-2" id=price>${dto.rep_price}원</div>
                  </div>
                <div class="row m-0 pb-2 pt-4">
                    <div class="col-3 p-0">거래방법</div>
                    <div class="col-9 p-0">${dto.rep_delivery}</div>
                </div>
                <div class="row m-0 pb-2">
                    <div class="col-3 p-0">배송비</div>
                    <div class="col-9 p-0">${dto.rep_delivery_price}</div>
                </div>
                
                <div class="row m-0 pb-4">
                    <div class="col-3 p-0">거래지역</div>
                    <div class="col-9 p-0">${dto.rep_area}</div>
                </div>
                <div class="row" id=crudBox>
                    <div class="col-8 p-0" id=>
						 <div class="row m-0 mt-3 mb-3">
						 	<div class="col-12 mb-1 ckT">상품판매관리</div>
						 	<div class="col-12 mb-1 ck">상태변경</div>
						 	<div class="col-4 sold">
						 		<input type=radio name="sold" value="판매중" ><span>판매중</span>
						 	</div>
						 	<div class="col-5 sold">
						 		<input type=radio name="sold" value="판매완료" ><span>판매완료</span>
						 	</div>
						 </div>
					</div>
                    <div class="col-4 p-0">
                    	<div class="row m-0">
						 	<div class="col-8 pt-1" id=update>수정</div>
						 	<div class="col-8 pt-1" id=delete>삭제</div>
						 </div>
                    </div>
                </div>
                <input type=hidden id=seq value="${dto.rep_seq}">
            </div>
        </div>
        <div class="row p-0 content">
            <div class="col-8">
                <div class="col-12 pb-2 pt-5" id=detailT>상세정보</div>
                <div class="col-12 pt-4 pb-4" >${dto.rep_detail}</div>
            </div>
            
        </div>
     
            <div class="row m-0">
                <div class="col-12" id=cmtT>댓글</div>
            </div>
            <div class="row cmtBox">
                <div class="col-11 p-0">
                    <textarea name="" id=content placeholder="댓글을 입력해주세요."></textarea>
                </div>
                <div class="col-1" id=cmtBtn>댓글등록
                </div>
            </div>
            <div class="box">
            	<c:forEach var="i" items="${cdto }">
            	<c:choose>
            	<c:when test="${id==i.recmt_writer }">
            		<div class="row recmtBox" seq="${i.recmt_seq }">
            			<div class="row m-0">
            				<div class="col-5 p-0 ID">${i.recmt_writer }<span>${i.recmt_write_date }</span></div>
            			</div>
            			<div class="row m-0">
            				<div class="col-5 p-0 cmt">${i.recmt_comments }</div>
            			</div>
            			<div class="row m-0">
            				<div class="col-12 p-0 btnBox">
            					<input type="button" class="modi" value="수정">
            					<input type="button" class="del" value="삭제">
            					<input type="hidden" class="recmt_seq" value="${i.recmt_seq }">
            				</div>
            			</div>
            		</div>
            	</c:when>
            	<c:otherwise>
            		<div class="row recmtBox">
            			<div class="row m-0">
            				<div class="col-5 p-0 ID">${i.recmt_writer }<span>${i.recmt_write_date }</span></div>
            			</div>
            			<div class="row m-0">
            				<div class="col-5 p-0 cmt">${i.recmt_comments }</div>
            			</div>
            		</div>
            	</c:otherwise>
            	</c:choose>
            	</c:forEach>
            	
            </div>

    </div>
		</c:when>
		<c:otherwise>
			 <div class="container-fluid">
        <div class="row m-0" id=menu>
            <div class="col-6 p-0" id=img>
            	<img src="/img/${pdto.reSysName }">
            </div>
            <div class="col-5 " id=infoBox>
            	<div class="row m-0 mb-4">
            		<div class="col-2 txt">개인중고</div>
            		<div class="col-2 ex">${dto.rep_diff_date} ·찜<span id=count></span></div>
            	</div>
            	
                <div class="row m-0">
                    <div class="col-12 p-0 pb-1" id=name>${dto.rep_name}</div>
                </div>
                <div class="row m-0" id=priceBox>
                    <div class="col-12 p-0 pb-2" id=price>${dto.rep_price}원</div>
                  </div>
                <div class="row m-0 pb-2 pt-4">
                    <div class="col-3 p-0">거래방법</div>
                    <div class="col-9 p-0">${dto.rep_delivery}</div>
                </div>
                <div class="row m-0 pb-2">
                    <div class="col-3 p-0">배송비</div>
                    <div class="col-9 p-0">${dto.rep_delivery_price}</div>
                </div>
                
                <div class="row m-0 pb-4">
                    <div class="col-3 p-0">거래지역</div>
                    <div class="col-9 p-0">${dto.rep_area}</div>
                </div>
                <div class="row pt-3" id=funcBox>
                    <div class="col-5 p-0" id=like>
						 <button class="btn btn-outline-dark" id=likeBtn>찜하기</button>
					</div>
                   
                </div>
                <input type=hidden id=seq value="${dto.rep_seq}">
            </div>
        </div>
        <div class="row p-0 content">
            <div class="col-8">
                <div class="col-12 pb-2 pt-5" id=detailT>상세정보</div>
                <div class="col-12 pt-4 pb-4" >${dto.rep_detail}</div>
            </div>
            <div class="col-3 p-0 pt-5" id=userBox>
                <div class="col-12 " id=userID>${dto.rep_writer}</div>
                 <div class="col-4 " id=repCount>상품 <span>${repCount}</span></div>
            </div>
        </div>
     
            <div class="row m-0">
                <div class="col-12" id=cmtT>댓글</div>
            </div>
            <div class="row cmtBox">
                <div class="col-11 p-0">
                    <textarea name="recmt_comments" id=content placeholder="댓글을 입력해주세요."></textarea>
                </div>
                <div class="col-1" id=cmtBtn>댓글등록
                </div>
            </div>
			<div class="box"></div>
    </div>
		</c:otherwise>
	</c:choose>
</body>
</html>