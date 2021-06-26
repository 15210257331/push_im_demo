import 'package:flutter/material.dart';

/// 是否启用缓存
const CACHE_ENABLE = false;

/// 缓存的最长时间，单位（秒）
const CACHE_MAXAGE = 1000;

/// 最大缓存数
const CACHE_MAXCOUNT = 100;

/// 用户 - 配置信息
const String STORAGE_USER_PROFILE_KEY = 'user_profile';

/// 设备是否第一次打开
const String STORAGE_DEVICE_ALREADY_OPEN_KEY = 'device_already_open';

/// 首页新闻cacheKey
const String STORAGE_INDEX_NEWS_CACHE_KEY = 'cache_index_news';

/// 用户设置的主题的key
const String THEME_KEY = 'theme_key';
