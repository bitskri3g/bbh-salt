{% extends "states/system/vm/prepare.sls" %}

{% block cpu %}{{ pillar[pillar_id]['cpu'] }}{% endblock cpu %}
{% block mem %}{{ pillar[pillar_id]['mem'] }}{% endblock mem %}
{% block network %}{{ pillar[pillar_id]['network'] }}{% endblock network %}
{% block os %}{{ pillar[pillar_id]['os'] }}{% endblock os %}
{% block hostname %}{{ pillar[pillar_id]['hostname'] }}{% endblock hostname %}
{% block disk %}{{ pillar[pillar_id]['disk'] }}{% endblock disk %}
