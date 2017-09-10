<div class="copyright" >
  
  {% set current = date(Date.now(), "YYYY") %}
  &copy; 
  2016 -
  <span itemprop="copyrightYear">{{ current }}</span>
  <span class="with-love">
    <i class="fa fa-flash"></i>
  </span>
  <span class="author" itemprop="copyrightHolder">Power By - {{ config.author }}</span>
</div>

{% if theme.copyright %}
<div class="powered-by">
  {{ __('footer.powered', '<a class="theme-link" href="https://hexo.io">Hexo</a>') }} 
</div>

<div class="theme-info">
  {{ __('footer.theme') }} - Leihoyoa
</div>


<script async src="https://dn-lbstatics.qbox.me/busuanzi/2.3/busuanzi.pure.mini.js"></script>
<div>
<i class="fa fa-eye">本站总访问量</i>
 <span id="busuanzi_value_site_pv"></span> &nbsp&nbsp |&nbsp&nbsp
<i class="fa fa-user">您是第</i><span id="busuanzi_value_site_uv"></span>个来到的小伙伴
</div>

<script>
var birthDay = new Date("11/20/2014");
var now = new Date();
var duration = now.getTime() - birthDay.getTime();
var total= Math.floor(duration / (1000 * 60 * 60 * 24));
document.getElementById("showDays").innerHTML = "本站已运行 "+total+" 天";
</script>
<span id="showDays"></span>

{% endif %}
