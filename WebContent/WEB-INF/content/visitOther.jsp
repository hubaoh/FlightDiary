<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="${pageContext.request.contextPath}/css/default.css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/css/visitOther.css" rel="stylesheet" />
    <script src="${pageContext.request.contextPath}/js/jquery-2.1.4.min.js">
    </script>
    <script src="${pageContext.request.contextPath}/js/layer/layer.js">
    </script>
    <script src="${pageContext.request.contextPath}/js/ramer/visitOther.js">
    </script>
    <title>
      Personal Center
    </title>
  </head>
  <body>
    <div class="return_link">
      <a href="${pageContext.request.contextPath}/home">
        返回主页
      </a>
      <br>
    </div>
    <div class="user_info_panel">
      <div class="head">
        <a>
          <img alt="error" src="${pageContext.request.contextPath}/${other.head }">
        </a>
      </div>
      <div class="selfinfo">
        <div class="name">
          ${other.name}
          <br>
        </div>
        <div class="contact">
          <span id="followSpan">
            <c:if test="${isFollowed eq true}">
             <a href="${pageContext.request.contextPath}/user/topic/notFollow" class="notFollow">
                <i class="icon-minus" id="icon"></i><i id="text" style="font-style: normal;">取消关注</i>
            </a>
          </c:if>
          <c:if test="${isFollowed ne true}">
            <a href="${pageContext.request.contextPath}/user/topic/follow" class="follow">
              <i class="icon-plus" id="icon"></i><i id="text" style="font-style: normal;">关注</i>
            </a>
          </c:if>
            </span>
            <span>
              QQ: ${!empty other.qqNum ? other.qqNum : "无"}
            </span>
            <span>
              微博: ${!empty other.weiboNum ? other.weiboNum : "无"}
            </span>
            <span>
              <a id="showFollowPanel" href="#">
                他/她关注的<i class="icon-arrow-down"></i>
              </a>
            </span>
            <span>
              <a href="javascript:void(0)" id="notifying">
                <i class="icon-envelope">
                </i>
              </a>
            </span>
          </div>
        </div>
      </div>

      <!-- 私信面板 -->
      <div class="notifying_panel" id="notifying_panel">
        <form 
            action="${pageContext.request.contextPath}/user/personal/sendPrivMess"
            method="post"
            enctype="multipart/form-data"
            id="sendPrivMessForm">

          <textarea id="privMessContent" rows="7" cols="30" class="notifying_content" name="content">
          </textarea>
          <br>
          <input type="submit" value="发送私信" id="sendPrivMess">
          <input type="reset" value="收起" class="hiddenNotifying">
        </form>
      </div>

      <!-- 关注面板 -->
      <div class="follow_panel clearfix" id="followPanel">
        <c:if test="${empty topic.user.follows }">
          <span>
            他/她还没有关注任何人 !
          </span>
        </c:if>
        <c:if test="${!empty topic.user.follows }">
          <c:forEach items="${topic.user.follows}" var="follow">
            <div class="followed_user_panel">
              <div>
                <a href="${pageContext.request.contextPath}/user/personal/${follow.followedUser.id}">
                  <img 
                      alt="error"
                      src="${pageContext.request.contextPath}/${follow.followedUser.head }"
                      class="followed_user_head">

                </a>
              </div>
              <div class="followed_user_name_panel">
                <a href="${pageContext.request.contextPath}/user/personal/${follow.followedUser.id}">
                  ${follow.followedUser.name}
                </a>
              </div>
            </div>
          </c:forEach>
        </c:if>
      </div>

      <!-- 显示他的分享 -->
      <c:if test="${empty other.topics}">
        <div class="no_topic">
          <strong>
            他还没有发布任何分享
          </strong>
        </div>
      </c:if>
      <c:if test="${!empty other.topics}">
        <c:forEach items="${other.topics}" var="topic">
          <div class="show_topic">
            <div class="side">
              <div class="day">
                <a href="#">
                  ${topic.date.date}/${topic.date.month+1}
                </a>
              </div>
            </div>
            <div class="main">
              <div class="content">
                <div class="img">
                  <img alt="error" src="${pageContext.request.contextPath}/${topic.picture}" class="topic_pic">
                  <p class="desc">
                  </p>
                </div>
                <div class="text">
                  ${topic.content }
                </div>
              </div>
            </div>

            <hr class="h_line">
            <c:set var="isPraise" value="false">
            </c:set>
            <c:forEach items="${praises }" var="p">
              <c:if test="${topic.id eq p }">
                <c:set var="isPraise" value="true">
                </c:set>
              </c:if>
            </c:forEach>
            <c:if test="${ isPraise eq true}">
              <a href="${pageContext.request.contextPath}/user/topic/notPraise/${topic.id}" class="thumbsup">
                <i class="icon-thumbs-up-ramer">
                </i>
              </a>
            </c:if>
            <c:if test="${ isPraise ne true}">
              <a href="${pageContext.request.contextPath}/user/topic/praise/${topic.id}" class="thumbsup">
                <i class="icon-thumbs-up">
                </i>
              </a>
            </c:if>
            <small class="upCounts">
              (${empty topic.upCounts ? 0 : topic.upCounts})
            </small>
            <a href="${pageContext.request.contextPath}/user/topic/comment/${topic.id}" class="comment">
              <i class="icon-edit">
              </i>
            </a>
            <c:set var="isFavourite" value="false">
            </c:set>
            <c:forEach items="${favourites }" var="f">
              <c:if test="${topic.id eq f }">
                <c:set var="isFavourite" value="true">
                </c:set>
              </c:if>
            </c:forEach>
            <c:if test="${ isFavourite eq true}">
              <a href="${pageContext.request.contextPath}/user/topic/notFavourite/${topic.id}" class="favourite">
                <i class="icon-star">
                </i>
              </a>
            </c:if>
            <c:if test="${ isFavourite ne true}">
              <a href="${pageContext.request.contextPath}/user/topic/favourite/${topic.id}" class="favourite">
                <i class="icon-star-empty">
                </i>
              </a>
            </c:if>
            <!-- 评论表单 -->
            <div class="comment_form_panel">
              <form action="" method="post" class="comment_form">
                <textarea rows="7" cols="30" class="comment_content" name="content">
                </textarea>
                <br>
                <input type="hidden" name="user" value="${user.id }" />
                <input type="submit" value="发表评论">
                <input type="reset" value="收起" class="hiddenCommentForm">
              </form>
            </div>
            <!-- 显示评论 -->
            <c:forEach items="${topic.comments}" var="comment">
              <div class="comment_panel">
                <p>
                  ${comment.user.name } : ${comment.content }
                  <sub>
                    &nbsp;&nbsp;${comment.date}
                  </sub>
                  <a href="${pageContext.request.contextPath}/user/topic/comment/reply/${comment.id}" class="reply">
                    <i class="icon-edit">
                    </i>
                  </a>
                </p>
                <!-- 回复评论表单 -->
                <div class="reply_form_panel">
                  <form action="" method="post" class="reply_form">
                    <textarea rows="7" cols="30" class="reply_content" name="content">
                    </textarea>
                    <br>
                    <input type="submit" value="发表评论">
                    <input type="reset" value="收起" class="hiddenReplyForm">
                  </form>
                </div>
                <c:forEach items="${comment.replies}" var="reply">
                  <p>
                    ${reply.user.name}&nbsp;回复&nbsp;${comment.user.name} : ${reply.content }
                    <sub>
                      &nbsp;&nbsp;${reply.date}
                    </sub>
                    <a 
                        href="${pageContext.request.contextPath}/user/topic/comment/reply/${reply.comment.id}"
                        class="reply2">

                      <i class="icon-edit">
                      </i>
                    </a>
                  </p>
                  <!-- 回复回复表单 -->
                  <div class="reply_double_form_panel">
                    <form action="" method="post" class="reply_double_form">
                      <textarea rows="7" cols="30" class="reply_double_content" name="content">
                      </textarea>
                      <br>
                      <input type="submit" value="回复">
                      <input type="reset" value="收起" class="hiddenReplyDoubleForm">
                    </form>
                  </div>
                </c:forEach>


              </div>
            </c:forEach>
          </div>
        </c:forEach>
      </c:if>
  </body>
</html>
