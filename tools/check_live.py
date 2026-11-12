"""Live smoke check of the published site: loads it, confirms the account client starts,
and confirms a signed-out browser cannot read the progress table.
Run: python3 tools/check_live.py   (needs: pip install playwright; playwright install chromium)"""
from playwright.sync_api import sync_playwright
U="https://molonych-source.github.io/steroid-pathway-trainer/"
with sync_playwright() as p:
    b=p.chromium.launch(); pg=b.new_page(); errs=[]; bad=[]
    pg.on("pageerror", lambda e: errs.append(str(e)))
    pg.on("console", lambda m: errs.append(m.text) if m.type=="error" else None)
    pg.on("response", lambda r: bad.append((r.status,r.url)) if r.status>=400 else None)
    pg.goto(U, wait_until="networkidle"); pg.wait_for_timeout(2500)
    print("title:", pg.title())
    print("acct:", pg.inner_text("#acct").strip()[:80])
    print("client ready:", pg.evaluate("!!(window.ST&&ST.Cloud&&ST.Cloud.client)"), "| uid:", pg.evaluate("ST.Cloud.uid"))
    print("session:", pg.evaluate("ST.Cloud.client.auth.getSession().then(r=>r.error?('ERR '+r.error.message):(r.data.session?'signed in':'none'))"))
    print("signed-out read:", pg.evaluate("ST.Cloud.client.from('steroid_progress').select('user_id').then(r=>r.error?('blocked: '+r.error.code+' '+r.error.message):('rows '+r.data.length))"))
    # Research mode (after 2026-11-12-research-setup.sql has been run): the function answers, a made-up
    # code is refused, and the research tables cannot be read from a browser.
    print("research_log, fake code:", pg.evaluate("ST.Cloud.client.rpc('research_log',{p_code:'ZZ-22222222',p_events:[{type:'visible'}]}).then(r=>r.error?('ERR '+r.error.code+' '+r.error.message):JSON.stringify(r.data))"), "(expect status unknown)")
    print("signed-out read research.events:", pg.evaluate("ST.Cloud.client.schema('research').from('events').select('id').then(r=>r.error?('blocked: '+r.error.code+' '+r.error.message):('rows '+r.data.length))"), "(expect blocked)")
    bad=[x for x in bad if 'research' not in x[1]]   # the blocked research read above is expected to fail
    print("js errors:", errs); print("bad responses:", bad)
    b.close()
