﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Идентификатор", Идентификатор);
	Параметры.Свойство("ДрайверОборудования", ДрайверОборудования);
	
	Заголовок = НСтр("ru='Оборудование:'") + Символы.НПП  + Строка(Идентификатор);
	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветОшибки = ЦветаСтиля.ЦветОтрицательногоЧисла;
	
	СписокПорт = Элементы.Порт.СписокВыбора;
	СписокПорт.Добавить(0, "<АВТО>");
	Для Номер = 1 По 64 Цикл
		СписокПорт.Добавить(Номер, "COM" + Формат(Номер, "ЧЦ=2; ЧДЦ=0; ЧН=0; ЧГ=0"));
	КонецЦикла;

	времПорт                        = Неопределено;
	времСкорость                    = Неопределено;
	времТаймаут                     = Неопределено;
	времПарольПользователя          = Неопределено;
	времПарольАдминистратора        = Неопределено;
	времИзображениеВКонце           = Неопределено;
	времИзображениеВНачале			= Неопределено;
	времИзображениеПосле			= Неопределено;
	времНаименованиеОплаты1			= Неопределено;
	времНаименованиеОплаты2			= Неопределено;
	времНомерСекции					= Неопределено;
	времНаличнаяОплата				= Неопределено;
	времКодСимволаЧастичногоОтреза	= Неопределено;
  
	Параметры.ПараметрыОборудования.Свойство("Порт"                       , времПорт);
	Параметры.ПараметрыОборудования.Свойство("Скорость"                   , времСкорость);
	Параметры.ПараметрыОборудования.Свойство("Таймаут"                    , времТаймаут);
	Параметры.ПараметрыОборудования.Свойство("ПарольПользователя"         , времПарольПользователя);
	Параметры.ПараметрыОборудования.Свойство("ПарольАдминистратора"       , времПарольАдминистратора);
	Параметры.ПараметрыОборудования.Свойство("ИзображениеВКонце"          , времИзображениеВКонце);
	Параметры.ПараметрыОборудования.Свойство("ИзображениеВНачале"         , времИзображениеВНачале);
	Параметры.ПараметрыОборудования.Свойство("ИзображениеПосле"           , времИзображениеПосле);
	Параметры.ПараметрыОборудования.Свойство("НаименованиеОплаты1"        , времНаименованиеОплаты1);
	Параметры.ПараметрыОборудования.Свойство("НаименованиеОплаты2"        , времНаименованиеОплаты2);
	Параметры.ПараметрыОборудования.Свойство("НомерСекции"                , времНомерСекции);
	Параметры.ПараметрыОборудования.Свойство("НаличнаяОплата"             , времНаличнаяОплата);
	Параметры.ПараметрыОборудования.Свойство("КодСимволаЧастичногоОтреза" , времКодСимволаЧастичногоОтреза);
	
	Порт                       = ?(времПорт                   		= Неопределено,    	0, времПорт);
	Скорость                   = ?(времСкорость                     = Неопределено, 19200, времСкорость);
	Таймаут                    = ?(времТаймаут                   	= Неопределено,  1500, времТаймаут);
	ПарольПользователя         = ?(времПарольПользователя     		= Неопределено,   	1, времПарольПользователя);
	ПарольАдминистратора       = ?(времПарольАдминистратора   		= Неопределено,    22, времПарольАдминистратора);
	ИзображениеВКонце     	   = ?(времИзображениеВКонце      		= Неопределено,   	0, времИзображениеВКонце);
	ИзображениеВНачале		   = ?(времИзображениеВНачале     		= Неопределено,   	0, времИзображениеВНачале);
	ИзображениеПосле       	   = ?(времИзображениеПосле       		= Неопределено,   	0, времИзображениеПосле);
	НаименованиеОплаты1        = ?(времНаименованиеОплаты1    		= Неопределено,    "", времНаименованиеОплаты1);
	НаименованиеОплаты2        = ?(времНаименованиеОплаты2    		= Неопределено,    "", времНаименованиеОплаты2);
	НаличнаяОплата             = ?(времНаличнаяОплата            	= Неопределено,     0, времНаличнаяОплата);
	НомерСекции                = ?(времНомерСекции            		= Неопределено,     0, времНомерСекции);
	КодСимволаЧастичногоОтреза = ?(времКодСимволаЧастичногоОтреза 	= Неопределено,    22, времКодСимволаЧастичногоОтреза);
	
	Элементы.ТестУстройства.Видимость = (ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто);
	Элементы.УстановитьДрайвер.Видимость = (ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто);
	Элементы.НомерСекции.Доступность = НаличнаяОплата;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьИнформациюОДрайвере();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаличнаяОплатаПриИзменении(Элемент)
	
	Элементы.НомерСекции.Доступность = НаличнаяОплата;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()

	НовыеЗначениеПараметров = Новый Структура;
	НовыеЗначениеПараметров.Вставить("Порт"                       , Порт);
	НовыеЗначениеПараметров.Вставить("Скорость"                   , Скорость);
	НовыеЗначениеПараметров.Вставить("Таймаут"                    , Таймаут);
	НовыеЗначениеПараметров.Вставить("ПарольПользователя"         , ПарольПользователя);
	НовыеЗначениеПараметров.Вставить("ПарольАдминистратора"       , ПарольАдминистратора);
	НовыеЗначениеПараметров.Вставить("ИзображениеВКонце"          , ИзображениеВКонце);
	НовыеЗначениеПараметров.Вставить("ИзображениеВНачале"         , ИзображениеВНачале);
	НовыеЗначениеПараметров.Вставить("ИзображениеПосле"           , ИзображениеПосле);
	НовыеЗначениеПараметров.Вставить("НаименованиеОплаты1"        , НаименованиеОплаты1);
	НовыеЗначениеПараметров.Вставить("НаименованиеОплаты2"        , НаименованиеОплаты2);
	НовыеЗначениеПараметров.Вставить("НомерСекции"                , НомерСекции);
	НовыеЗначениеПараметров.Вставить("НаличнаяОплата"             , НаличнаяОплата);
	НовыеЗначениеПараметров.Вставить("КодСимволаЧастичногоОтреза" , КодСимволаЧастичногоОтреза);
	
	Результат = Новый Структура;
	Результат.Вставить("Идентификатор", Идентификатор);
	Результат.Вставить("ПараметрыОборудования", НовыеЗначениеПараметров);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)

	ОчиститьСообщения();

	РезультатТеста    = Неопределено;

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"							, Порт);
	времПараметрыУстройства.Вставить("Скорость"						, Скорость);
	времПараметрыУстройства.Вставить("Таймаут"						, Таймаут);
    времПараметрыУстройства.Вставить("ПарольПользователя"			, ПарольПользователя);
	времПараметрыУстройства.Вставить("ПарольАдминистратора"			, ПарольАдминистратора);
	времПараметрыУстройства.Вставить("ИзображениеВКонце"			, ИзображениеВКонце);
	времПараметрыУстройства.Вставить("ИзображениеВНачале"			, ИзображениеВНачале);
	времПараметрыУстройства.Вставить("ИзображениеПосле"				, ИзображениеПосле);
	времПараметрыУстройства.Вставить("НаименованиеОплаты1"			, НаименованиеОплаты1);
	времПараметрыУстройства.Вставить("НаименованиеОплаты2"			, НаименованиеОплаты2);
	времПараметрыУстройства.Вставить("НомерСекции"					, НомерСекции);
	времПараметрыУстройства.Вставить("НаличнаяОплата"				, НаличнаяОплата);
	времПараметрыУстройства.Вставить("КодСимволаЧастичногоОтреза"	, КодСимволаЧастичногоОтреза);
	
	Результат = МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("CheckHealth",
																		  ВходныеПараметры,
																		  ВыходныеПараметры,
																		  Идентификатор,
																		  времПараметрыУстройства);

	ДополнительноеОписание = ?(ТипЗнч(ВыходныеПараметры) = Тип("Массив")
							   И ВыходныеПараметры.Количество(),
							   НСтр("ru = 'Дополнительное описание:'") + " " + ВыходныеПараметры[1],
							   "");
	Если Результат Тогда
		ТекстСообщения = НСтр("ru = 'Тест успешно выполнен.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПереводСтроки%", ?(ПустаяСтрока(ДополнительноеОписание),
																		  "",
																		  Символы.ПС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание),
																				   "",
																				   ДополнительноеОписание));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Иначе
		ТекстСообщения = НСтр("ru = 'Тест не пройден.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПереводСтроки%", ?(ПустаяСтрока(ДополнительноеОписание),
																		  "",
																		  Символы.ПС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание),
																				   "",
																				   ДополнительноеОписание));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УстановкаДрайвераЗавершение(Результат, Параметры) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		АдресЗагрузкиДрайвера = "http://www.orion-uta.ru/";
		ПерейтиПоНавигационнойСсылке(АдресЗагрузкиДрайвера);
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура УстановитьДрайвер(Команда)
	
	ОчиститьСообщения();
	Текст = НСтр("ru = 'Установка производиться средствами дистрибутива поставщика.
		|Перейти на сайт поставщика для скачивания?'");
	Оповещение = Новый ОписаниеОповещения("УстановкаДрайвераЗавершение",  ЭтотОбъект);
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере()

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"							, Порт);
	времПараметрыУстройства.Вставить("Скорость"						, Скорость);
	времПараметрыУстройства.Вставить("Таймаут"						, Таймаут);
	времПараметрыУстройства.Вставить("ПарольПользователя"			, ПарольПользователя);
	времПараметрыУстройства.Вставить("ПарольАдминистратора"			, ПарольАдминистратора);
	времПараметрыУстройства.Вставить("ИзображениеВКонце"			, ИзображениеВКонце);
	времПараметрыУстройства.Вставить("ИзображениеВНачале"			, ИзображениеВНачале);
	времПараметрыУстройства.Вставить("ИзображениеПосле"				, ИзображениеПосле);
	времПараметрыУстройства.Вставить("НаименованиеОплаты1"			, НаименованиеОплаты1);
	времПараметрыУстройства.Вставить("НаименованиеОплаты2"			, НаименованиеОплаты2);
	времПараметрыУстройства.Вставить("НомерСекции"					, НомерСекции);
	времПараметрыУстройства.Вставить("НаличнаяОплата"				, НаличнаяОплата);
	времПараметрыУстройства.Вставить("КодСимволаЧастичногоОтреза"	, КодСимволаЧастичногоОтреза);


	Если МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("ПолучитьВерсиюДрайвера",
																   ВходныеПараметры,
																   ВыходныеПараметры,
				 												   Идентификатор,
																   времПараметрыУстройства) Тогда
		Драйвер = ВыходныеПараметры[0];
		Версия  = ВыходныеПараметры[1];
	Иначе
		Драйвер = ВыходныеПараметры[2];
		Версия  = НСтр("ru='Не определена'");
	КонецЕсли;                                           
	
	Элементы.Драйвер.ЦветТекста = ?(Драйвер = НСтр("ru='Не установлен'"), ЦветОшибки, ЦветТекста);
	Элементы.Версия.ЦветТекста  = ?(Версия  = НСтр("ru='Не определена'"), ЦветОшибки, ЦветТекста);
	
	Элементы.УстановитьДрайвер.Доступность = Не (Драйвер = НСтр("ru='Установлен'"));
	
КонецПроцедуры

#КонецОбласти