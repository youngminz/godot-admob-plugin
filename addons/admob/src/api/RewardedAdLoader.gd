# MIT License

# Copyright (c) 2023-present Poing Studios

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

class_name RewardedAdLoader
extends MobileSingletonPlugin

static var _plugin = _get_plugin("PoingGodotAdMobRewardedAd")

var rewarded_ad_load_callback : RewardedAdLoadCallback
var _uid : int

func _init():
	if _plugin:
		_uid = _plugin.create()

func load(
	ad_unit_id : String, 
	ad_request : AdRequest, 
	rewarded_ad_load_callback := RewardedAdLoadCallback.new()) -> void:

	if _plugin:
		self.rewarded_ad_load_callback = rewarded_ad_load_callback
		_plugin.load(ad_unit_id, ad_request.convert_to_dictionary(), ad_request.keywords, _uid)
		_plugin.connect("on_rewarded_ad_loaded", _on_rewarded_ad_loaded, CONNECT_ONE_SHOT)
		_plugin.connect("on_rewarded_ad_failed_to_load", _on_rewarded_ad_failed_to_load, CONNECT_ONE_SHOT)

func _on_rewarded_ad_loaded(uid : int) -> void:
	if uid == _uid:
		rewarded_ad_load_callback.on_ad_loaded.call_deferred(RewardedAd.new(uid))

func _on_rewarded_ad_failed_to_load(uid : int, load_ad_error_dictionary : Dictionary) -> void: 
	if uid == _uid:
		rewarded_ad_load_callback.on_ad_failed_to_load.call_deferred(LoadAdError.create(load_ad_error_dictionary))
