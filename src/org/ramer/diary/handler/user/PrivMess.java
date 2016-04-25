package org.ramer.diary.handler.user;

import java.io.IOException;
import java.util.Date;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.ramer.diary.domain.Notifying;
import org.ramer.diary.domain.Topic;
import org.ramer.diary.domain.User;
import org.ramer.diary.exception.IllegalAccessException;
import org.ramer.diary.exception.SystemWrongException;
import org.ramer.diary.service.NotifyService;
import org.ramer.diary.util.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

/**
 * 发送私信和读取私信.
 * @author ramer
 *
 */
@SessionAttributes(value = { "user", "topics", }, types = { User.class, Topic.class })
@Controller
public class PrivMess {

  @Autowired
  private NotifyService notifyService;

  /**
   * 发送私信.
   *
   * @param user 用户
   * @param content 私信内容
   * @param map the map
   * @param response the response
   * @param session the session
   * @throws IOException Signals that an I/O exception has occurred.
   */
  @RequestMapping("/user/personal/sendPrivMess")
  public void sendPrivMess(User user, @RequestParam("content") String content,
      Map<String, Object> map, HttpServletResponse response, HttpSession session)
      throws IOException {
    System.out.println("发送私信");
    response.setCharacterEncoding("utf-8");
    if (!UserUtils.checkLogin(session)) {
      response.getWriter().write("需要先登录才能说悄悄话哦");
      System.out.println("未登录");
      return;
    }
    if (content.trim() == null || content.trim() == "") {
      System.out.println("消息为空");
      response.getWriter().write("消息不能为空");
      return;
    }
    User notifiedUser = new User();
    notifiedUser = (User) session.getAttribute("other");
    System.out.println("被通知用户 = " + notifiedUser);
    Notifying notifying = new Notifying();
    notifying.setUser(user);
    notifying.setNotifiedUser(notifiedUser);
    notifying.setContent(content);
    notifying.setDate(new Date());
    notifying.setHasCheck("false");
    boolean flag = notifyService.sendPrivMess(notifying);
    response.setCharacterEncoding("utf-8");
    if (!flag) {
      System.out.println("消息发送失败");
      response.getWriter().write("系统正在打麻将,请稍后再试");
      return;
    }
    System.out.println("消息发送成功");
    response.getWriter().write("消息发送成功");
  }

  /**
   * 用户阅读消息.
   *
   * @param notifyId 信息UID
   * @param map the map
   * @param session the session
   * @return 重定向到个人主页
   */
  @RequestMapping("/user/personal/readPrivMess")
  public String readPrivMess(@RequestParam("notifyId") String notifyId, Map<String, Object> map,
      HttpSession session) {
    System.out.println("读取私信 : " + notifyId);
    Notifying notifying = new Notifying();
    Integer notify_id = -1;
    try {
      notify_id = Integer.parseInt(notifyId);
    } catch (Exception e) {
      throw new IllegalAccessException("数据格式有误");
    }
    if (notify_id > 0) {
      notifying.setId(notify_id);
      notifying = notifyService.getNotifyingById(notifying);
      notifying.setHasCheck("true");
      boolean flag = notifyService.updateNotifying(notifying);
      if (!flag) {
        throw new SystemWrongException();
      }
    } else {
      throw new IllegalAccessException("数据格式有误");
    }
    return "redirect:/user/personal";
  }

}