﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ВнешниеРесурсыРазрешены;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновитьСписокВыбораПлановОбмена();
	
	ОбновитьСписокВыбораМакетаПравил();
	
	ОбновитьИнформациюОПравилах();
	
	ОбновитьИсточникПравил();
	
	СобытиеЖурналаРегистрацииЗагрузкаПравилДляОбменаДанными = ОбменДаннымиСервер.СобытиеЖурналаРегистрацииЗагрузкаПравилДляОбменаДанными();
	
	Элементы.ГруппаПланаОбмена.Видимость = ПустаяСтрока(Запись.ИмяПланаОбмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ВнешниеРесурсыРазрешены <> Истина Тогда
		
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("РазрешитьВнешнийРесурсЗавершение", ЭтотОбъект, ПараметрыЗаписи);
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
			Запросы = СоздатьЗапросНаИспользованиеВнешнихРесурсов(Запись);
			МодульРаботаВБезопасномРежимеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаВБезопасномРежимеКлиент");
			МодульРаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(Запросы, ЭтотОбъект, ОповещениеОЗакрытии);
		Иначе
			ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, КодВозвратаДиалога.ОК);
		КонецЕсли;
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	ВнешниеРесурсыРазрешены = Ложь;
	
	Если ИсточникПравил = "ТиповыеИзКонфигурации" Тогда
		// Из конфигурации
		ВыполнитьЗагрузкуПравил(Неопределено, "", Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.Свойство("ЗаписатьИЗакрыть") Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИмяПланаОбменаПриИзменении(Элемент)
	
	Запись.ИмяМакетаПравил = "";
	
	// вызов сервера
	ОбновитьСписокВыбораМакетаПравил();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсточникПравилПриИзменении(Элемент)
	
	Элементы.ИсточникФайл.Доступность = (ИсточникПравил = "ЗагруженныеИзФайла");
	
	Если ИсточникПравил = "ТиповыеИзКонфигурации" Тогда
		
		Запись.РежимОтладки = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьПравила(Команда)
	
	ОчиститьСообщения();
	
	// Из файла с клиента
	ЧастиИмени = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(Запись.ИмяФайлаПравил);
	
	ПараметрыДиалога = Новый Структура;
	ПараметрыДиалога.Вставить("Заголовок", НСтр("ru = 'Укажите, из какого файла загрузить правила'"));
	ПараметрыДиалога.Вставить("Фильтр",
		  НСтр("ru = 'Файлы правил регистрации (*.xml)'") + "|*.xml|"
		+ НСтр("ru = 'Архивы ZIP (*.zip)'")   + "|*.zip");
	
	ПараметрыДиалога.Вставить("ПолноеИмяФайла", ЧастиИмени.ПолноеИмя);
	ПараметрыДиалога.Вставить("ИндексФильтра", ?( НРег(ЧастиИмени.Расширение) = ".zip", 1, 0) ); 
	
	Оповещение = Новый ОписаниеОповещения("ЗагрузитьПравилаЗавершение", ЭтотОбъект);
	ОбменДаннымиКлиент.ВыбратьИПередатьФайлНаСервер(Оповещение, ПараметрыДиалога, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьПравила(Команда)
	
	ЧастиИмени = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(Запись.ИмяФайлаПравил);
	
	АдресХранения = ПолучитьНавигационнуюСсылкуНаСервере();
	ФильтрИмени = НСтр("ru = 'Файлы правил (*.xml)'") + "|*.xml";
	
	Если ПустаяСтрока(АдресХранения) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(ЧастиИмени.ИмяБезРасширения) Тогда
		ПолноеИмяФайла = НСтр("ru = 'Правила регистрации'");
	Иначе
		ПолноеИмяФайла = ЧастиИмени.ИмяБезРасширения;
	КонецЕсли;
	
	ПараметрыДиалога = Новый Структура;
	ПараметрыДиалога.Вставить("Режим", РежимДиалогаВыбораФайла.Сохранение);
	ПараметрыДиалога.Вставить("Заголовок", НСтр("ru = 'Укажите в какой файл выгрузить правила'") );
	ПараметрыДиалога.Вставить("ПолноеИмяФайла", ПолноеИмяФайла);
	ПараметрыДиалога.Вставить("Фильтр", ФильтрИмени);
	
	ПолучаемыйФайл = Новый Структура("Имя, Хранение", ПолноеИмяФайла, АдресХранения);
	
	ОбменДаннымиКлиент.ВыбратьИСохранитьФайлНаКлиенте(ПолучаемыйФайл, ПараметрыДиалога);

	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("ЗаписатьИЗакрыть");
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПоказатьЖурналРегистрацииПриОшибке(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Отбор = Новый Структура;
		Отбор.Вставить("СобытиеЖурналаРегистрации", СобытиеЖурналаРегистрацииЗагрузкаПравилДляОбменаДанными);
		ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", Отбор, ЭтотОбъект, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокВыбораПлановОбмена()
	
	СписокПлановОбмена = ОбменДаннымиПовтИсп.СписокПлановОбменаБСП();
	
	ЗаполнитьСписок(СписокПлановОбмена, Элементы.ИмяПланаОбмена.СписокВыбора);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокВыбораМакетаПравил()
	
	Если ПустаяСтрока(Запись.ИмяПланаОбмена) Тогда
		
		Элементы.ГруппаОсновная.Заголовок = НСтр("ru = 'Правила конвертации'");
		
	Иначе
		
		Элементы.ГруппаОсновная.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Элементы.ГруппаОсновная.Заголовок, Метаданные.ПланыОбмена[Запись.ИмяПланаОбмена].Синоним);
		
	КонецЕсли;
	
	СписокМакетов = ОбменДаннымиПовтИсп.ПравилаРегистрацииДляПланаОбменаИзКонфигурации(Запись.ИмяПланаОбмена);
	
	СписокВыбора = Элементы.ИмяМакетаПравил.СписокВыбора;
	СписокВыбора.Очистить();
	
	ЗаполнитьСписок(СписокМакетов, СписокВыбора);
	
	Элементы.ИсточникМакетКонфигурации.ТекущаяСтраница = ?(СписокМакетов.Количество() = 1,
		Элементы.СтраницаОдинМакет, Элементы.СтраницаНесколькоМакетов);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписок(СписокИсточник, СписокПриемник)
	
	Для Каждого Элемент Из СписокИсточник Цикл
		
		ЗаполнитьЗначенияСвойств(СписокПриемник.Добавить(), Элемент);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПравилаНаСервере(Отказ, АдресВременногоХранилища, ИмяФайлаПравил, ЭтоАрхив)
	
	Запись.ИсточникПравил = ?(ИсточникПравил = "ТиповыеИзКонфигурации",
		Перечисления.ИсточникиПравилДляОбменаДанными.МакетКонфигурации, Перечисления.ИсточникиПравилДляОбменаДанными.Файл);
	
	Объект = РеквизитФормыВЗначение("Запись");
	
	РегистрыСведений.ПравилаДляОбменаДанными.ЗагрузитьПравила(Отказ, Объект, АдресВременногоХранилища, ИмяФайлаПравил, ЭтоАрхив);
	
	Если Не Отказ Тогда
		
		Объект.Записать();
		
		Модифицированность = Ложь;
		
		// Кэш открытых сеансов для механизма регистрации стал неактуальным.
		ОбменДаннымиВызовСервера.СброситьКэшМеханизмаРегистрацииОбъектов();
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(Объект, "Запись");
	
	ОбновитьИнформациюОПравилах();
	Элементы.ГруппаПланаОбмена.Видимость = ПустаяСтрока(Запись.ИмяПланаОбмена);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьНавигационнуюСсылкуНаСервере()
	
	Отбор = Новый Структура;
	Отбор.Вставить("ИмяПланаОбмена", Запись.ИмяПланаОбмена);
	Отбор.Вставить("ВидПравил",      Запись.ВидПравил);
	
	КлючЗаписи = РегистрыСведений.ПравилаДляОбменаДанными.СоздатьКлючЗаписи(Отбор);
	
	Возврат ПолучитьНавигационнуюСсылку(КлючЗаписи, "ПравилаXML");
	
КонецФункции

&НаСервере
Процедура ОбновитьИнформациюОПравилах()
	
	Если Запись.ИсточникПравил = Перечисления.ИсточникиПравилДляОбменаДанными.Файл Тогда
		
		ИнформацияОПравилах = НСтр("ru = 'Использование правил, загруженных из файла,
									|может привести к ошибкам при переходе на новую версию программы.
									|
									|[ИнформацияОПравилах]'");
		
		ИнформацияОПравилах = СтрЗаменить(ИнформацияОПравилах, "[ИнформацияОПравилах]", Запись.ИнформацияОПравилах);
		
	Иначе
		
		ИнформацияОПравилах = Запись.ИнформацияОПравилах;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИсточникПравил()
	
	ИсточникПравил = ?(Запись.ИсточникПравил = Перечисления.ИсточникиПравилДляОбменаДанными.МакетКонфигурации,
		"ТиповыеИзКонфигурации", "ЗагруженныеИзФайла");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузкуПравил(Знач АдресПомещенногоФайла, Знач ИмяФайла, Знач ЭтоАрхив)
	Отказ = Ложь;
	
	ЗагрузитьПравилаНаСервере(Отказ, АдресПомещенногоФайла, ИмяФайла, ЭтоАрхив);
	
	Если Не Отказ Тогда
		ПоказатьОповещениеПользователя(,, НСтр("ru = 'Правила успешно загружены в информационную базу.'"));
		Возврат;
	КонецЕсли;
	
	ТекстОшибки = НСтр("ru = 'В процессе загрузки правил были обнаружены ошибки.
	                         |Перейти в журнал регистрации?'");
	
	Оповещение = Новый ОписаниеОповещения("ПоказатьЖурналРегистрацииПриОшибке", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстОшибки, РежимДиалогаВопрос.ДаНет, ,КодВозвратаДиалога.Нет);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПравилаЗавершение(Знач РезультатПомещенияФайлов, Знач ДополнительныеПараметры) Экспорт
	
	АдресПомещенногоФайла = РезультатПомещенияФайлов.Хранение;
	ТекстОшибки           = РезультатПомещенияФайлов.ОписаниеОшибки;
	
	Если ПустаяСтрока(ТекстОшибки) И ПустаяСтрока(АдресПомещенногоФайла) Тогда
		ТекстОшибки = НСтр("ru = 'Ошибка передачи файла на сервер'");
	КонецЕсли;
	
	Если Не ПустаяСтрока(ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Возврат;
	КонецЕсли;
		
	ИсточникПравил = "ЗагруженныеИзФайла";
	
	// Успешно передали файл, загружаем на сервере.
	ЧастиИмени = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(РезультатПомещенияФайлов.Имя);
	
	ВыполнитьЗагрузкуПравил(АдресПомещенногоФайла, ЧастиИмени.Имя, НРег(ЧастиИмени.Расширение) = ".zip");
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьВнешнийРесурсЗавершение(Результат, ПараметрыЗаписи) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ВнешниеРесурсыРазрешены = Истина;
		Записать(ПараметрыЗаписи);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СоздатьЗапросНаИспользованиеВнешнихРесурсов(Знач Запись)
	
	ЗапросыРазрешений = Новый Массив;
	ПравилаКонвертацииИзФайла = РегистрыСведений.ПравилаДляОбменаДанными.ПравилаКонвертацииИзФайла(Запись.ИмяПланаОбмена);
	ЕстьПравилаКонвертации = (ПравилаКонвертацииИзФайла <> Неопределено);
	ПравилаРегистрацииИзФайла = (Запись.ИсточникПравил = Перечисления.ИсточникиПравилДляОбменаДанными.Файл);
	РегистрыСведений.ПравилаДляОбменаДанными.ЗапросНаИспользованиеВнешнихРесурсов(ЗапросыРазрешений,
		?(ЕстьПравилаКонвертации, ПравилаКонвертацииИзФайла, Запись), ЕстьПравилаКонвертации, ПравилаРегистрацииИзФайла);
	Возврат ЗапросыРазрешений;
	
КонецФункции

#КонецОбласти
