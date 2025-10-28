package com.K1ll4a.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class HitListBean implements Serializable {
    private final List<HitResult> history = new ArrayList<>();

    public List<HitResult> getHistory() { return Collections.unmodifiableList(history); }
    public void add(HitResult hr) { history.add(hr); }
    public void clear() { history.clear(); }
}
