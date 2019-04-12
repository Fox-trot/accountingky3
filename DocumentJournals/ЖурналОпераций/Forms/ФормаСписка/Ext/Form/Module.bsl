﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Документы.ОперацияБух);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
		
	ИспользуетсяНесколькоОрганизаций = Справочники.Организации.ИспользуетсяНесколькоОрганизаций();
	
	ТипИнформации = "Контрагент";
	НастроитьВнешнийВидОтбораИнформация();
	УстановитьОграничениеТипаОтбораИнформации(ЭтотОбъект);
	
	Если Не ПустаяСтрока(Параметры.Заголовок) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	ИспользуетсяОтборПоКритериюОтбора = Ложь; // отборы по контрагенту и договору могут изменяться после открытия
	
	Элементы.СписокОрганизация.Видимость = ИспользуетсяНесколькоОрганизаций;
	// Отбор по основной организации
	Если ИспользуетсяНесколькоОрганизаций Тогда
		ОтборОрганизация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
		ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
		ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	КонецЕсли;
	
	Элементы.ГруппаОтборДоговорКонтрагента.Видимость = Истина;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаГлобальныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	АдресХранилищаНастройкиДинСпискаДляРеестра = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	ЗаполнитьСписокДокументовОснований();
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	// По графе "Информация" может быть быстрый отбор как по контрагенту, так и по сотруднику.		
	Если ТипЗнч(Настройки["ОтборИнформация"]) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		
		Если Элементы.ТипИнформации.СписокВыбора.НайтиПоЗначению("Сотрудник") <> Неопределено Тогда
			
			ТипИнформации = "Сотрудник";
			
		Иначе	
			ТипИнформации                = "Контрагент";
			ОтборИнформация              = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
			ОтборИнформацияИспользование = Ложь;	
		КонецЕсли;
		
	Иначе	
		ТипИнформации = "Контрагент";
		ОтборКонтрагент = ОтборИнформация;	
	КонецЕсли;
	
	УстановитьОграничениеТипаОтбораИнформации(ЭтотОбъект);
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Информация");	
	
	УстановитьСвязиПараметровВыбораДоговораКонтрагента();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		
		ОтборОрганизация = Параметр;
		ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
		ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
		
		УстановитьСвязиПараметровВыбораДоговораКонтрагента();	
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Строка") Или ПустаяСтрока(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
		
	СвойстваДоговора = Неопределено;
	Если ОтборДоговорКонтрагентаИспользование И ЗначениеЗаполнено(ОтборДоговорКонтрагента) Тогда
		СвойстваДоговора = ПараметрыВыбораДоговораКонтрагента(ОтборДоговорКонтрагента);
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
		
	Если ОтборОрганизацияИспользование Тогда
		ЗначенияЗаполнения.Вставить("Организация", ОтборОрганизация);
	ИначеЕсли СвойстваДоговора <> Неопределено Тогда
		ЗначенияЗаполнения.Вставить("Организация", СвойстваДоговора.Организация);
	КонецЕсли;
	
	Если ОтборИнформацияИспользование Тогда
		Если ТипИнформации = "Сотрудник" Тогда
			ЗначенияЗаполнения.Вставить("ФизЛицо", ОтборИнформация);
		Иначе
			ЗначенияЗаполнения.Вставить("Контрагент", ОтборИнформация);
		КонецЕсли;
	ИначеЕсли СвойстваДоговора <> Неопределено Тогда
		ЗначенияЗаполнения.Вставить("Контрагент", СвойстваДоговора.Владелец);
	КонецЕсли;
	
	Если ОтборДоговорКонтрагентаИспользование Тогда
		Если Не ЗначенияЗаполнения.Свойство("Контрагент")
		   И ЗначениеЗаполнено(ОтборИнформация) Тогда
			ЗначенияЗаполнения.Вставить("Контрагент", ОтборИнформация);
		КонецЕсли;
		ЗначенияЗаполнения.Вставить("ДоговорКонтрагента", ОтборДоговорКонтрагента);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ." + ВыбранноеЗначение + ".ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацияИспользованиеПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	
	УстановитьСвязиПараметровВыбораДоговораКонтрагента();	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ОтборОрганизация) Тогда
		ОтборОрганизацияИспользование = Истина;
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	
	УстановитьСвязиПараметровВыбораДоговораКонтрагента();
КонецПроцедуры

&НаКлиенте
Процедура ТипИнформацииПриИзменении(Элемент)
	
	УстановитьОграничениеТипаОтбораИнформации(ЭтотОбъект);
	ОтборИнформацияИспользование = Ложь;
	ОтборДоговорКонтрагентаИспользование = Ложь;
	Если ТипИнформации = "Сотрудник" Тогда
		
		ОтборИнформация = ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка");
			
	Иначе
			
		ОтборИнформация = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
		ОтборДоговорКонтрагента = Неопределено;
		
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Информация");
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "ДоговорКонтрагента");
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ОтборИнформацияИспользованиеПриИзменении(Элемент)
	
	Если ТипИнформации = "Контрагент" Тогда
		ОтборКонтрагент = ОтборИнформация;
	КонецЕсли;
		
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Информация");
	
	УстановитьСвязиПараметровВыбораДоговораКонтрагента();
КонецПроцедуры

&НаКлиенте
Процедура ОтборИнформацияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ОтборИнформация) Тогда
		ОтборИнформацияИспользование = Истина;
	КонецЕсли;
	
	Если ТипИнформации = "Контрагент" Тогда
		ОтборКонтрагент = ОтборИнформация;
	КонецЕсли;	
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Информация");
	
	УстановитьСвязиПараметровВыбораДоговораКонтрагента();
КонецПроцедуры

&НаКлиенте
Процедура ОтборДоговорКонтрагентаИспользованиеПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "ДоговорКонтрагента");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборДоговорКонтрагентаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ОтборДоговорКонтрагента) Тогда
		ОтборДоговорКонтрагентаИспользование = Истина;
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "ДоговорКонтрагента");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		РезультатПоиска = СписокДокументовОснований.НайтиПоЗначению(ТипЗнч(ТекущиеДанные.Ссылка));
		
		Если РезультатПоиска = Неопределено Тогда
			Элементы.СоздатьНаОсновании.Доступность = Ложь;
		Иначе	
			Элементы.СоздатьНаОсновании.Доступность = Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не Копирование Тогда
		
		Отказ = Истина;
		
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		
		ПараметрыФормы = Новый Структура;
		
		Если ТекущиеДанные <> Неопределено Тогда
			ПараметрыФормы.Вставить("НачальноеЗначение", ТипЗнч(ТекущиеДанные.Ссылка));
		КонецЕсли;
		
		ОткрытьФорму("ЖурналДокументов.ЖурналОпераций.Форма.ВыборТипаДокумента", ПараметрыФормы, ЭтотОбъект, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПереключитьАктивностьПроводок(Команда)

	ТекДанные = Элементы.Список.ТекущиеДанные;

	Если ТекДанные = Неопределено Тогда
		ПоказатьПредупреждение( , НСтр("ru = 'Не выбран документ'"));
		Возврат;
	КонецЕсли;

	ПереключитьАктивностьПроводокСервер(ТекДанные.Ссылка);

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНаОсновании(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	ПараметрыФормы = Новый Структура;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы.Вставить("Основание", ТекущиеДанные.Ссылка);
	КонецЕсли;
	
	ОткрытьФорму("ЖурналДокументов.ЖурналОпераций.Форма.ВыборТипаДокумента", ПараметрыФормы, ЭтотОбъект, Истина);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()

	Если ТипИнформации = "Сотрудник" Тогда
		Элементы.ОтборДоговорКонтрагента.Видимость = Ложь;
		Элементы.ОтборДоговорКонтрагентаИспользование.Видимость = Ложь;
	Иначе
		Элементы.ОтборДоговорКонтрагента.Видимость = Истина;
		Элементы.ОтборДоговорКонтрагентаИспользование.Видимость = Истина;
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПереключитьАктивностьПроводокСервер(ТекДокумент)

	БухгалтерскийУчетПереопределяемый.ПереключитьАктивностьПроводокБУ(ТекДокумент);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОграничениеТипаОтбораИнформации(Форма)

	Если Форма.ТипИнформации = "Сотрудник" Тогда
		Форма.Элементы.ОтборИнформация.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица");
	Иначе
		Форма.Элементы.ОтборИнформация.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура НастроитьВнешнийВидОтбораИнформация()

	ТипыОтбора = Элементы.ТипИнформации.СписокВыбора;
	
	ЕдинственныйТипОтбора = ТипыОтбора.Количество() = 1;
	
	Элементы.ТипИнформации.Видимость = Не ЕдинственныйТипОтбора;
	Элементы.ОтборИнформацияИспользование.ПоложениеЗаголовка = ?(ЕдинственныйТипОтбора,
		ПоложениеЗаголовкаЭлементаФормы.Лево, ПоложениеЗаголовкаЭлементаФормы.Нет);
	
	Если ЕдинственныйТипОтбора Тогда
		
		// Установим название отбора из единственного доступного типа
		НазваниеОтбора = СтрЗаменить(ТипыОтбора[0].Представление, ":", "");
		
		Элементы.ОтборИнформацияИспользование.Заголовок = НазваниеОтбора;
		Элементы.СписокИнформация.Заголовок = НазваниеОтбора; 
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьСвязиПараметровВыбораДоговораКонтрагента()

	МассивСвязей = Новый Массив;
	
	Если ОтборИнформацияИспользование Тогда
		МассивСвязей.Добавить(Новый СвязьПараметраВыбора("Отбор.Владелец", "ОтборИнформация", РежимИзмененияСвязанногоЗначения.Очищать));
	КонецЕсли;
	
	Если ОтборОрганизацияИспользование Тогда
		МассивСвязей.Добавить(Новый СвязьПараметраВыбора("Отбор.Организация", "ОтборОрганизация", РежимИзмененияСвязанногоЗначения.Очищать));
	КонецЕсли;
	
	Элементы.ОтборДоговорКонтрагента.СвязиПараметровВыбора = Новый ФиксированныйМассив(МассивСвязей);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПараметрыВыбораДоговораКонтрагента(Знач ДоговорКонтрагента)
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДоговорКонтрагента, "Владелец, Организация");
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокДокументовОснований()

	СписокДокументовОснований.Добавить(Тип("ДокументСсылка.АвансовыйОтчет"));
	СписокДокументовОснований.Добавить(Тип("ДокументСсылка.ПоступлениеТоваровУслуг"));
	СписокДокументовОснований.Добавить(Тип("ДокументСсылка.РасходныйКассовыйОрдер"));
	СписокДокументовОснований.Добавить(Тип("ДокументСсылка.РеализацияТоваровУслуг"));
	СписокДокументовОснований.Добавить(Тип("ДокументСсылка.ВозвратТоваровОтПокупателя"));
	СписокДокументовОснований.Добавить(Тип("ДокументСсылка.ВозвратТоваровПоставщику"));
	СписокДокументовОснований.Добавить(Тип("ДокументСсылка.СчетНаОплатуПокупателю"));
	СписокДокументовОснований.Добавить(Тип("ДокументСсылка.СчетНаОплатуПоставщика"));
	СписокДокументовОснований.Добавить(Тип("ДокументСсылка.ДополнительныеРасходы"));
	СписокДокументовОснований.Добавить(Тип("ДокументСсылка.ПлатежноеПоручениеИсходящее"));
	
КонецПроцедуры

&НаСервере
Процедура НастройкиДинамическогоСписка(Идентификатор)
	
	Отчеты.РеестрДокументов.НастройкиДинамическогоСписка(ЭтотОбъект,,Идентификатор);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Если СтрНайти(Команда.Имя, "Реестр") <> 0 Тогда
		Идентификатор = Сред(Команда.Имя,22);
		НастройкиДинамическогоСписка(Идентификатор);
	КонецЕсли;
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
