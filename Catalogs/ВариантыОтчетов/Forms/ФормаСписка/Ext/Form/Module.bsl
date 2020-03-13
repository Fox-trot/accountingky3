﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ОпределитьПоведениеВМобильномКлиенте();
	ПараметрыКлиента = ВариантыОтчетов.ПараметрыКлиента();
	ВключаяПодчиненные = Истина;
	
	ДеревоЗначений = ВариантыОтчетовПовтИсп.ПодсистемыТекущегоПользователя().Скопировать();
	ДеревоПодсистемЗаполнитьПолноеПредставление(ДеревоЗначений.Строки);
	ЗначениеВРеквизитФормы(ДеревоЗначений, "ДеревоПодсистем");
	
	ДеревоПодсистемТекущаяСтрока = -1;
	Элементы.ДеревоПодсистем.ТекущаяСтрока = 0;
	Если Параметры.РежимВыбора = Истина Тогда
		РежимРаботыФормы = "Выбор";
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		Элементы.Список.Отображение = ОтображениеТаблицы.Список;
	ИначеЕсли Параметры.РазделСсылка <> Неопределено Тогда
		РежимРаботыФормы = "ВсеОтчетыРаздела";
		РодительскиеЭлементы = Новый Массив; // Массив из ДанныеФормыЭлементДерева
		РодительскиеЭлементы.Добавить(ДеревоПодсистем.ПолучитьЭлементы()[0]);
		Пока РодительскиеЭлементы.Количество() > 0 Цикл
			РодительскийЭлемент = РодительскиеЭлементы[0].ПолучитьЭлементы(); // ДанныеФормыКоллекцияЭлементовДерева
			РодительскиеЭлементы.Удалить(0);
			Для Каждого ДочернийЭлемент Из РодительскийЭлемент Цикл
				Если ДочернийЭлемент.Ссылка = Параметры.РазделСсылка Тогда
					Элементы.ДеревоПодсистем.ТекущаяСтрока = ДочернийЭлемент.ПолучитьИдентификатор();
					РодительскиеЭлементы.Очистить();
					Прервать;
				КонецЕсли;
				РодительскиеЭлементы.Добавить(ДочернийЭлемент);
			КонецЦикла;
		КонецЦикла;
	Иначе
		РежимРаботыФормы = "Список";
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Изменить", "Отображение", ОтображениеКнопки.КартинкаИТекст);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "РазместитьВРазделах", "ТолькоВоВсехДействиях", Ложь);
	КонецЕсли;
	
	ГлобальныеНастройки = ВариантыОтчетов.ГлобальныеНастройки();
	Элементы.СтрокаПоиска.ПодсказкаВвода = ГлобальныеНастройки.Поиск.ПодсказкаВвода;
	
	КлючСохраненияПоложенияОкна = РежимРаботыФормы;
	КлючНазначенияИспользования = РежимРаботыФормы;
	
	УстановитьСвойствоСпискаПоПараметруФормы("РежимВыбора");
	УстановитьСвойствоСпискаПоПараметруФормы("ВыборГруппИЭлементов");
	УстановитьСвойствоСпискаПоПараметруФормы("МножественныйВыбор");
	УстановитьСвойствоСпискаПоПараметруФормы("ТекущаяСтрока");
	
	Элементы.Выбрать.КнопкаПоУмолчанию = Параметры.РежимВыбора;
	Элементы.Выбрать.Видимость = Параметры.РежимВыбора;
	Элементы.ОтборТипОтчета.Видимость = ВариантыОтчетов.ПолныеПраваНаВарианты();
	
	СписокВыбора = Элементы.ОтборТипОтчета.СписокВыбора;
	СписокВыбора.Добавить(1, НСтр("ru = 'Все, кроме внешних'"));
	СписокВыбора.Добавить(Перечисления.ТипыОтчетов.Внутренний,     НСтр("ru = 'Внутренние'"));
	СписокВыбора.Добавить(Перечисления.ТипыОтчетов.Расширение,     НСтр("ru = 'Расширения'"));
	СписокВыбора.Добавить(Перечисления.ТипыОтчетов.Дополнительный, НСтр("ru = 'Дополнительные'"));
	СписокВыбора.Добавить(Перечисления.ТипыОтчетов.Внешний,        НСтр("ru = 'Внешние'"));
	
	СтрокаПоиска = Параметры.СтрокаПоиска;
	Если Параметры.Отбор.Свойство("ТипОтчета", ОтборТипОтчета) Тогда
		Параметры.Отбор.Удалить("ТипОтчета");
	КонецЕсли;
	Если Параметры.ТолькоВарианты Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"КлючВарианта", "", ВидСравненияКомпоновкиДанных.НеРавно,,,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
	КонецЕсли;
	
	ПерсональныеНастройкиСписка = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		ВариантыОтчетовКлиентСервер.ПолноеИмяПодсистемы(),
		"Справочник.ВариантыОтчетов.ФормаСписка");
	Если ПерсональныеНастройкиСписка <> Неопределено Тогда
		Элементы.СтрокаПоиска.СписокВыбора.ЗагрузитьЗначения(ПерсональныеНастройкиСписка.СтрокаПоискаСписокВыбора);
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ДоступныеОтчеты", ВариантыОтчетов.ОтчетыТекущегоПользователя());
	Список.Параметры.УстановитьЗначениеПараметра("ОтключенныеВариантыПрограммы", Новый Массив(ВариантыОтчетовПовтИсп.ОтключенныеВариантыПрограммы()));
	Список.Параметры.УстановитьЗначениеПараметра("ЭтоОсновнойЯзык", ТекущийЯзык() = Метаданные.ОсновнойЯзык);
	Список.Параметры.УстановитьЗначениеПараметра("КодЯзыка", ТекущийЯзык().КодЯзыка);
	Список.Параметры.УстановитьЗначениеПараметра("ВерсияРасширений", ПараметрыСеанса.ВерсияРасширений);
	
	ТекущийЭлемент = Элементы.Список;
	
	ВариантыОтчетов.ДополнитьОтборыИзСтруктуры(Список.КомпоновщикНастроек.Настройки.Отбор, Параметры.Отбор);
	Параметры.Отбор.Очистить();
	
	ОбновитьСодержимоеСписка("ПриСозданииНаСервере");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если РежимРаботыФормы = "ВсеОтчетыРаздела" ИЛИ РежимРаботыФормы = "Выбор" Тогда
		Элементы.ДеревоПодсистем.Развернуть(ДеревоПодсистемТекущаяСтрока, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = ВариантыОтчетовКлиент.ИмяСобытияИзменениеВарианта()
		Или ИмяСобытия = "Запись_НаборКонстант" Тогда
		ДеревоПодсистемТекущаяСтрока = -1;
		ПодключитьОбработчикОжидания("ДеревоПодсистемОбработчикАктивизацииСтроки", 0.1, Истина);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборТипОтчетаПриИзменении(Элемент)
	ОбновитьСодержимоеСписка();
КонецПроцедуры

&НаКлиенте
Процедура ОтборТипОтчетаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОтборТипОтчета = Неопределено;
	ОбновитьСодержимоеСписка();
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	ОбновитьСодержимоеСпискаКлиент("СтрокаПоискаПриИзменении");
КонецПроцедуры

&НаКлиенте
Процедура ВключаяПодчиненныеПриИзменении(Элемент)
	ДеревоПодсистемТекущаяСтрока = -1;
	ПодключитьОбработчикОжидания("ДеревоПодсистемОбработчикАктивизацииСтроки", 0.1, Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПодсистем

&НаКлиенте
Процедура ДеревоПодсистемПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодсистемПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодсистемПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодсистемПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("ДеревоПодсистемОбработчикАктивизацииСтроки", 0.1, Истина);
	
#Если МобильныйКлиент Тогда
	ПодключитьОбработчикОжидания("УстановитьЗаголовокДереваПодсистем", 0.1, Истина);
	ТекущийЭлемент = Элементы.Список;
#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодсистемПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
	
	Если Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыРазмещения = ПараметрыРазмещения(ПараметрыПеретаскивания, Строка);
	Если ПараметрыРазмещения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыРазмещения.Варианты.Всего = 1 Тогда
		Если ПараметрыРазмещения.Действие = "Копирование" Тогда
			ШаблонВопроса = НСтр("ru = 'Разместить ""%1"" в ""%4""?'");
		Иначе
			ШаблонВопроса = НСтр("ru = 'Переместить ""%1"" из ""%3"" в ""%4""?'");
		КонецЕсли;
	Иначе
		Если ПараметрыРазмещения.Действие = "Копирование" Тогда
			ШаблонВопроса = НСтр("ru = 'Разместить варианты отчетов ""%1"" (%2 шт.) в ""%4""?'");
		Иначе
			ШаблонВопроса = НСтр("ru = 'Переместить варианты отчетов ""%1"" (%2 шт.) из ""%3"" в ""%4""?'");
		КонецЕсли;
	КонецЕсли;
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонВопроса,
		ПараметрыРазмещения.Варианты.Представление,
		Формат(ПараметрыРазмещения.Варианты.Всего, "ЧГ=0"),
		ПараметрыРазмещения.Источник.ПолноеПредставление,
		ПараметрыРазмещения.Приемник.ПолноеПредставление);
	
	Обработчик = Новый ОписаниеОповещения("ДеревоПодсистемПеретаскиваниеЗавершение", ЭтотОбъект, ПараметрыРазмещения);
	ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	ВариантыОтчетовКлиент.ПоказатьНастройкиОтчета(Элементы.Список.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если РежимРаботыФормы = "ВсеОтчетыРаздела" Тогда
		СтандартнаяОбработка = Ложь;
		ВариантыОтчетовКлиент.ОткрытьФормуОтчета(ЭтотОбъект, Элементы.Список.ТекущиеДанные);
	ИначеЕсли РежимРаботыФормы = "Список" Тогда
		СтандартнаяОбработка = Ложь;
		ВариантыОтчетовКлиент.ПоказатьНастройкиОтчета(ВыбраннаяСтрока);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьПоиск(Команда)
	ОбновитьСодержимоеСпискаКлиент("ВыполнитьПоиск");
КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	ВариантыОтчетовКлиент.ПоказатьНастройкиОтчета(Элементы.Список.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВариантОтчетаВФайл(Команда)
	ВариантОтчета = Элементы.Список.ТекущаяСтрока;
	Если Не ЗначениеЗаполнено(ВариантОтчета) Тогда 
		Возврат;
	КонецЕсли;
	
	ПараметрыСохранения = Новый Структура(ВариантыОтчетовКлиентСервер.СвойстваСохраненияВариантаОтчета());
	ПараметрыСохранения.ВариантОтчета = ВариантОтчета;
	
	ОткрытьФорму(
		"ХранилищеНастроек.ХранилищеВариантовОтчетов.Форма.СохранениеВариантаОтчетаВФайл",
		ПараметрыСохранения,
		ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВариантОтчетаИзФайла(Команда)
	Ссылка = Элементы.Список.ТекущаяСтрока;
	
	Если ТипЗнч(Ссылка) <> Тип("СправочникСсылка.ВариантыОтчетов") Тогда 
		Возврат;
	КонецЕсли;
	
	СвойстваВариантаОтчета = ВариантыОтчетовКлиент.СвойстваВариантаОтчетаОснования();
	СвойстваВариантаОтчета.Ссылка = Ссылка;
	СвойстваВариантаОтчета.ПредставлениеВарианта = Строка(Ссылка);
	
	Обработчик = Новый ОписаниеОповещения(
		"ОбновитьВариантОтчетаИзФайла", ВариантыОтчетовКлиент, СвойстваВариантаОтчета);
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.Диалог.Фильтр = НСтр("ru = 'Архив ZIP (*.zip)|*.zip'");
	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;
	
	ФайловаяСистемаКлиент.ЗагрузитьФайл(Обработчик, ПараметрыЗагрузки);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОпределитьПоведениеВМобильномКлиенте()
	Если Не ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда 
		Возврат;
	КонецЕсли;
	
	Элементы.СтрокаПоиска.Ширина = 0;
	Элементы.СтрокаПоиска.РастягиватьПоГоризонтали = Неопределено;
	Элементы.СтрокаПоиска.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	Элементы.СтрокаПоиска.КнопкаВыпадающегоСписка = Ложь;
	Элементы.ВыполнитьПоиск.Отображение = ОтображениеКнопки.Картинка;
КонецПроцедуры

&НаСервере
Процедура ДеревоПодсистемЗаполнитьПолноеПредставление(НаборСтрок, ПредставлениеРодителя = "")
	Для Каждого СтрокаДерева Из НаборСтрок Цикл
		Если ПустаяСтрока(СтрокаДерева.Имя) Тогда
			СтрокаДерева.ПолноеПредставление = "";
		ИначеЕсли ПустаяСтрока(ПредставлениеРодителя) Тогда
			СтрокаДерева.ПолноеПредставление = СтрокаДерева.Представление;
		Иначе
			СтрокаДерева.ПолноеПредставление = ПредставлениеРодителя + "." + СтрокаДерева.Представление;
		КонецЕсли;
		ДеревоПодсистемЗаполнитьПолноеПредставление(СтрокаДерева.Строки, СтрокаДерева.ПолноеПредставление);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Описание.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Описание");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	ЦветПоясняющегоТекста = Метаданные.ЭлементыСтиля.ПоясняющийТекст;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветПоясняющегоТекста.Значение);
	
КонецПроцедуры

// Возвращает параметры перетаскивания.
// 
// Параметры:
//  ПараметрыПеретаскивания - ПараметрыПеретаскивания - 
//  Строка - Число - 
//
// Возвращаемое значение:
//  Неопределено - 
//  Структура - где:
//    * Варианты - Структура - где:
//        ** Массив - Массив из ДанныеФормыЭлементДерева - 
//        ** Всего - Число - 
//        ** Представление - Строка - 
//    * Действие - Строка - 
//    * Приемник - см. СвойстваДанныхСтроки
//    * Источник - см. СвойстваДанныхСтроки
//
&НаКлиенте
Функция ПараметрыРазмещения(ПараметрыПеретаскивания, Строка)
	
	КоличествоСтрок = ПараметрыПеретаскивания.Значение.Количество();
	Если КоличествоСтрок = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтрокаПриемник = ДеревоПодсистем.НайтиПоИдентификатору(Строка);
	Если СтрокаПриемник = Неопределено ИЛИ СтрокаПриемник.Приоритет = "" Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыРазмещения = Новый Структура("Варианты, Действие, Приемник, Источник");
	ПараметрыРазмещения.Варианты = Новый Структура("Массив, Всего, Представление");
	ПараметрыРазмещения.Варианты.Массив = ПараметрыПеретаскивания.Значение;
	ПараметрыРазмещения.Варианты.Всего  = КоличествоСтрок;
	
	Приемник = СвойстваДанныхСтроки();
	ЗаполнитьЗначенияСвойств(Приемник, СтрокаПриемник);
	Приемник.Идентификатор = СтрокаПриемник.ПолучитьИдентификатор();
	
	ПараметрыРазмещения.Приемник = Приемник;
	
	СтрокаИсточник = Элементы.ДеревоПодсистем.ТекущиеДанные;
	Источник = СвойстваДанныхСтроки();
	Если СтрокаИсточник = Неопределено ИЛИ СтрокаИсточник.Приоритет = "" Тогда
		ПараметрыРазмещения.Действие = "Копирование";
	Иначе
		ЗаполнитьЗначенияСвойств(Источник, СтрокаИсточник);
		Источник.Идентификатор = СтрокаИсточник.ПолучитьИдентификатор();
		Если ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Копирование Тогда
			ПараметрыРазмещения.Действие = "Копирование";
		Иначе
			ПараметрыРазмещения.Действие = "Перемещение";
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыРазмещения.Источник = Источник;
	
	Если Источник.Ссылка = Приемник.Ссылка Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выбранные варианты отчетов уже в данном разделе.'"));
		Возврат Неопределено;
	КонецЕсли;
	
	Если ПараметрыРазмещения.Варианты.Всего = 1 Тогда
		ПараметрыРазмещения.Варианты.Представление = Строка(ПараметрыРазмещения.Варианты.Массив[0]);
	Иначе
		ПараметрыРазмещения.Варианты.Представление = "";
		Для Каждого ВариантСсылка Из ПараметрыРазмещения.Варианты.Массив Цикл
			ПараметрыРазмещения.Варианты.Представление = ПараметрыРазмещения.Варианты.Представление
				+ ?(ПараметрыРазмещения.Варианты.Представление = "", "", ", ")
				+ Строка(ВариантСсылка);
			
			Если СтрДлина(ПараметрыРазмещения.Варианты.Представление) > 23 Тогда
				ПараметрыРазмещения.Варианты.Представление = Лев(ПараметрыРазмещения.Варианты.Представление, 20) + "...";
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ПараметрыРазмещения;
	
КонецФункции

// Конструктор свойств данных строки.
// 
// Возвращаемое значение:
//  Структура - где:
//    * Ссылка - Неопределено - 
//             - СправочникСсылка.ИдентификаторыОбъектовРасширений - 
//             - СправочникСсылка.ИдентификаторыОбъектовМетаданных - 
//    * ПолноеПредставление - Строка - 
//    * Идентификатор - Число - 
//
&НаКлиенте
Функция СвойстваДанныхСтроки()
	
	Свойства = Новый Структура;
	Свойства.Вставить("Ссылка", Неопределено);
	Свойства.Вставить("ПолноеПредставление", "");
	Свойства.Вставить("Идентификатор", 0);
	
	Возврат Свойства;
	
КонецФункции

// Обработчик завершения перетаскивания.
//
// Параметры:
//  Ответ - КодВозвратаДиалога - 
//  ПараметрыРазмещения - Структура - где:
//    * Варианты - Структура - где:
//        ** Массив - Массив из ДанныеФормыЭлементДерева - 
//        ** Всего - Число - 
//        ** Представление - Строка - 
//    * Действие - Строка - 
//    * Приемник - ДанныеФормыЭлементДерева - 
//    * Источник - ДанныеФормыЭлементДерева - 
//
&НаКлиенте
Процедура ДеревоПодсистемПеретаскиваниеЗавершение(Ответ, ПараметрыРазмещения) Экспорт
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	РезультатВыполнения = РазместитьВариантыВПодсистеме(ПараметрыРазмещения);
	ВариантыОтчетовКлиент.ОбновитьОткрытыеФормы();
	
	Если ПараметрыРазмещения.Варианты.Всего = РезультатВыполнения.Размещено Тогда
		Если ПараметрыРазмещения.Варианты.Всего = 1 Тогда
			Если ПараметрыРазмещения.Действие = "Перемещение" Тогда
				Шаблон = НСтр("ru = 'Успешно перемещен в ""%1"".'");
			Иначе
				Шаблон = НСтр("ru = 'Успешно размещен в ""%1"".'");
			КонецЕсли;
			Текст = ПараметрыРазмещения.Варианты.Представление;
			Ссылка = ПолучитьНавигационнуюСсылку(ПараметрыРазмещения.Варианты.Массив[0]);
		Иначе
			Если ПараметрыРазмещения.Действие = "Перемещение" Тогда
				Шаблон = НСтр("ru = 'Успешно перемещены в ""%1"".'");
			Иначе
				Шаблон = НСтр("ru = 'Успешно размещены в ""%1"".'");
			КонецЕсли;
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Варианты отчетов (%1).'"), Формат(ПараметрыРазмещения.Варианты.Всего, "ЧН=0; ЧГ=0"));
			Ссылка = Неопределено;
		КонецЕсли;
		Шаблон = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, ПараметрыРазмещения.Приемник.ПолноеПредставление);
		ПоказатьОповещениеПользователя(Шаблон, Ссылка, Текст);
	Иначе
		ТекстОшибок = "";
		Если Не ПустаяСтрока(РезультатВыполнения.НеМогутРазмещаться) Тогда
			ТекстОшибок = ?(ТекстОшибок = "", "", ТекстОшибок + Символы.ПС + Символы.ПС)
				+ НСтр("ru = 'Не могут размещаться в командном интерфейсе:'")
				+ Символы.ПС
				+ РезультатВыполнения.НеМогутРазмещаться;
		КонецЕсли;
		Если Не ПустаяСтрока(РезультатВыполнения.УжеРазмещены) Тогда
			ТекстОшибок = ?(ТекстОшибок = "", "", ТекстОшибок + Символы.ПС + Символы.ПС)
				+ НСтр("ru = 'Уже размещены в этом разделе:'")
				+ Символы.ПС
				+ РезультатВыполнения.УжеРазмещены;
		КонецЕсли;
		
		Если ПараметрыРазмещения.Действие = "Перемещение" Тогда
			Шаблон = НСтр("ru = 'Перемещено вариантов отчетов: %1 из %2.
				|Подробности:
				|%3'");
		Иначе
			Шаблон = НСтр("ru = 'Размещено вариантов отчетов: %1 из %2.
				|Подробности:
				|%3'");
		КонецЕсли;
		
		СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(Неопределено, 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, РезультатВыполнения.Размещено, 
				ПараметрыРазмещения.Варианты.Всего, ТекстОшибок), РежимДиалогаВопрос.ОК);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвойствоСпискаПоПараметруФормы(Ключ)
	
	Если Параметры.Свойство(Ключ) И ЗначениеЗаполнено(Параметры[Ключ]) Тогда
		Элементы.Список[Ключ] = Параметры[Ключ];
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСодержимоеСписка(Знач Событие = "")
	ИзменилисьПерсональныеНастройки = Ложь;
	Если ЗначениеЗаполнено(СтрокаПоиска) Тогда
		СписокВыбора = Элементы.СтрокаПоиска.СписокВыбора;
		ЭлементСписка = СписокВыбора.НайтиПоЗначению(СтрокаПоиска);
		Если ЭлементСписка = Неопределено Тогда
			СписокВыбора.Вставить(0, СтрокаПоиска);
			ИзменилисьПерсональныеНастройки = Истина;
			Если СписокВыбора.Количество() > 10 Тогда
				СписокВыбора.Удалить(10);
			КонецЕсли;
		Иначе
			Индекс = СписокВыбора.Индекс(ЭлементСписка);
			Если Индекс <> 0 Тогда
				СписокВыбора.Сдвинуть(Индекс, -Индекс);
				ИзменилисьПерсональныеНастройки = Истина;
			КонецЕсли;
		КонецЕсли;
		ТекущийЭлемент = Элементы.СтрокаПоиска;
	КонецЕсли;
	
	Если Событие = "СтрокаПоискаПриИзменении" И ИзменилисьПерсональныеНастройки Тогда
		ПерсональныеНастройкиСписка = Новый Структура("СтрокаПоискаСписокВыбора");
		ПерсональныеНастройкиСписка.СтрокаПоискаСписокВыбора = Элементы.СтрокаПоиска.СписокВыбора.ВыгрузитьЗначения();
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			ВариантыОтчетовКлиентСервер.ПолноеИмяПодсистемы(),
			"Справочник.ВариантыОтчетов.ФормаСписка",
			ПерсональныеНастройкиСписка);
	КонецЕсли;
	
	ДеревоПодсистемТекущаяСтрока = Элементы.ДеревоПодсистем.ТекущаяСтрока;
	
	СтрокаДерева = ДеревоПодсистем.НайтиПоИдентификатору(ДеревоПодсистемТекущаяСтрока);
	Если СтрокаДерева = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВсеПодсистемы = Не ЗначениеЗаполнено(СтрокаДерева.ПолноеИмя);
	
	ПараметрыПоиска = Новый Структура;
	Если ЗначениеЗаполнено(СтрокаПоиска) Тогда
		ПараметрыПоиска.Вставить("СтрокаПоиска", СтрокаПоиска);
		Элементы.Список.НачальноеОтображениеДерева = НачальноеОтображениеДерева.РаскрыватьВсеУровни;
	Иначе
		Элементы.Список.НачальноеОтображениеДерева = НачальноеОтображениеДерева.НеРаскрывать;
	КонецЕсли;
	Если Не ВсеПодсистемы Или ЗначениеЗаполнено(СтрокаПоиска) Тогда
		ПодсистемыОтчетов = Новый Массив;
		Если Не ВсеПодсистемы Тогда
			ПодсистемыОтчетов.Добавить(СтрокаДерева.Ссылка);
		КонецЕсли;
		Если ВсеПодсистемы Или ВключаяПодчиненные Тогда
			ДобавитьРекурсивно(ПодсистемыОтчетов, СтрокаДерева.ПолучитьЭлементы());
		КонецЕсли;
		ПараметрыПоиска.Вставить("Подсистемы", ПодсистемыОтчетов);
	КонецЕсли;
	Если ЗначениеЗаполнено(ОтборТипОтчета) Тогда
		ТипыОтчетов = Новый Массив;
		Если ОтборТипОтчета = 1 Тогда
			ТипыОтчетов.Добавить(Перечисления.ТипыОтчетов.Внутренний);
			ТипыОтчетов.Добавить(Перечисления.ТипыОтчетов.Расширение);
			ТипыОтчетов.Добавить(Перечисления.ТипыОтчетов.Дополнительный);
		Иначе
			ТипыОтчетов.Добавить(ОтборТипОтчета);
		КонецЕсли;
		ПараметрыПоиска.Вставить("ТипыОтчетов", ТипыОтчетов);
	КонецЕсли;
	
	ЕстьОтборПоВариантам = ПараметрыПоиска.Количество() > 0;
	ПараметрыПоиска.Вставить("ПометкаУдаления", Ложь);
	ПараметрыПоиска.Вставить("ЖесткийОтборПоПодсистемам", Не ВсеПодсистемы);
	
	РезультатПоиска = ВариантыОтчетов.НайтиВариантыОтчетов(ПараметрыПоиска);
	Список.Параметры.УстановитьЗначениеПараметра("ЕстьОтборПоВариантам", ЕстьОтборПоВариантам);
	Список.Параметры.УстановитьЗначениеПараметра("ВариантыПользователя", РезультатПоиска.Ссылки);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодсистемОбработчикАктивизацииСтроки()
	Если ДеревоПодсистемТекущаяСтрока <> Элементы.ДеревоПодсистем.ТекущаяСтрока Тогда
		ОбновитьСодержимоеСписка();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗаголовокДереваПодсистем()
	Элементы.ГруппаРазделы.Заголовок = ?(Элементы.ДеревоПодсистем.ТекущиеДанные = Неопределено,
		НСтр("ru = 'Все разделы'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка()),
		Элементы.ДеревоПодсистем.ТекущиеДанные.Представление);
КонецПроцедуры

&НаСервере
Процедура ДобавитьРекурсивно(МассивПодсистем, КоллекцияСтрокДерева)
	Для Каждого СтрокаДерева Из КоллекцияСтрокДерева Цикл
		МассивПодсистем.Добавить(СтрокаДерева.Ссылка);
		ДобавитьРекурсивно(МассивПодсистем, СтрокаДерева.ПолучитьЭлементы());
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ДеревоПодсистемЗаписатьСвойствоВМассив(МассивСтрокДерева, ИмяСвойства, МассивСсылок)
	Для Каждого СтрокаДерева Из МассивСтрокДерева Цикл
		МассивСсылок.Добавить(СтрокаДерева[ИмяСвойства]);
		ДеревоПодсистемЗаписатьСвойствоВМассив(СтрокаДерева.ПолучитьЭлементы(), ИмяСвойства, МассивСсылок);
	КонецЦикла;
КонецПроцедуры

// Записывает данные о размещении варианта отчета.
//
// Параметры:
//  ПараметрыРазмещения - см. ПараметрыРазмещения
//
// Возвращаемое значение:
//  Структура - где:
//    * Размещено - Число - 
//    * УжеРазмещены - Строка - 
//    * НеМогутРазмещаться - Строка - 
//
&НаСервере
Функция РазместитьВариантыВПодсистеме(ПараметрыРазмещения)
	ИсключаемыеПодсистемы = Новый Массив;
	Если ПараметрыРазмещения.Действие = "Перемещение" Тогда
		Источник = ПараметрыРазмещения.Источник; // см. СвойстваДанныхСтроки
		СтрокаИсточник = ДеревоПодсистем.НайтиПоИдентификатору(Источник.Идентификатор);
		ИсключаемыеПодсистемы.Добавить(СтрокаИсточник.Ссылка);
		ДеревоПодсистемЗаписатьСвойствоВМассив(СтрокаИсточник.ПолучитьЭлементы(), "Ссылка", ИсключаемыеПодсистемы);
	КонецЕсли;
	
	Размещено = 0;
	УжеРазмещены = "";
	НеМогутРазмещаться = "";
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЗаблокироватьВариантыОтчетовПередРазмещением(Блокировка, ПараметрыРазмещения.Варианты.Массив);
		Блокировка.Заблокировать();
		
		Для Каждого ВариантСсылка Из ПараметрыРазмещения.Варианты.Массив Цикл
			Если ВариантСсылка.ТипОтчета = Перечисления.ТипыОтчетов.Внешний Тогда
				НеМогутРазмещаться = ?(НеМогутРазмещаться = "", "", НеМогутРазмещаться + Символы.ПС)
					+ "  "
					+ Строка(ВариантСсылка)
					+ " ("
					+ НСтр("ru = 'внешний'")
					+ ")";
				Продолжить;
			ИначеЕсли ВариантСсылка.ПометкаУдаления Тогда
				НеМогутРазмещаться = ?(НеМогутРазмещаться = "", "", НеМогутРазмещаться + Символы.ПС)
					+ "  "
					+ Строка(ВариантСсылка)
					+ " ("
					+ НСтр("ru = 'помечен на удаление'")
					+ ")";
				Продолжить;
			КонецЕсли;
			
			ЕстьИзменения = Ложь;
			ВариантОбъект = ВариантСсылка.ПолучитьОбъект(); // СправочникОбъект.ВариантыОтчетов - 
			
			Приемник = ПараметрыРазмещения.Приемник; // см. СвойстваДанныхСтроки
			СтрокаПриемник = ВариантОбъект.Размещение.Найти(Приемник.Ссылка, "Подсистема");
			Если СтрокаПриемник = Неопределено Тогда
				СтрокаПриемник = ВариантОбъект.Размещение.Добавить();
				СтрокаПриемник.Подсистема = Приемник.Ссылка;
			КонецЕсли;
			
			// Удаление строки из исходной подсистемы.
			// Важно помнить что исключение предопределенного варианта из подсистемы выполняется путем выключения флажка
			// подсистемы.
			Если ПараметрыРазмещения.Действие = "Перемещение" Тогда
				Для Каждого ИсключаемаяПодсистема Из ИсключаемыеПодсистемы Цикл
					СтрокаИсточник = ВариантОбъект.Размещение.Найти(ИсключаемаяПодсистема, "Подсистема");
					Если СтрокаИсточник <> Неопределено Тогда
						Если СтрокаИсточник.Использование Тогда
							СтрокаИсточник.Использование = Ложь;
							Если Не ЕстьИзменения Тогда
								ЗаполнитьЗначенияСвойств(СтрокаПриемник, СтрокаИсточник, "Важный, СмТакже");
								ЕстьИзменения = Истина;
							КонецЕсли;
						КонецЕсли;
						СтрокаИсточник.Важный  = Ложь;
						СтрокаИсточник.СмТакже = Ложь;
					ИначеЕсли Не ВариантОбъект.Пользовательский Тогда
						СтрокаИсточник = ВариантОбъект.Размещение.Добавить();
						СтрокаИсточник.Подсистема = ИсключаемаяПодсистема;
						ЕстьИзменения = Истина;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			// Регистрация строки в подсистеме-приемнике.
			Если Не СтрокаПриемник.Использование Тогда
				ЕстьИзменения = Истина;
				СтрокаПриемник.Использование = Истина;
			КонецЕсли;
			
			Если ЕстьИзменения Тогда
				Размещено = Размещено + 1;
				ВариантОбъект.Записать();
			Иначе
				УжеРазмещены = ?(УжеРазмещены = "", "", УжеРазмещены + Символы.ПС)
					+ "  "
					+ Строка(ВариантСсылка);
			КонецЕсли;
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Если ПараметрыРазмещения.Действие = "Перемещение" И Размещено > 0 Тогда
		Элементы.ДеревоПодсистем.ТекущаяСтрока = Приемник.Идентификатор;
		ОбновитьСодержимоеСписка();
	КонецЕсли;
	
	Возврат Новый Структура("Размещено, УжеРазмещены, НеМогутРазмещаться", Размещено, УжеРазмещены, НеМогутРазмещаться);
КонецФункции

&НаСервере
Процедура ЗаблокироватьВариантыОтчетовПередРазмещением(Блокировка, ВариантыОтчетов)
	
	ИсточникДанных = Новый ТаблицаЗначений;
	ИсточникДанных.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("СправочникСсылка.ВариантыОтчетов"));
	
	Для Каждого ВариантОтчета Из ВариантыОтчетов Цикл 
		Строка = ИсточникДанных.Добавить();
		Строка.Ссылка = ВариантОтчета;
	КонецЦикла;
	
	ЭлементБлокировки = Блокировка.Добавить("Справочник.ВариантыОтчетов");
	ЭлементБлокировки.ИсточникДанных = ИсточникДанных;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Ссылка", "Ссылка");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСодержимоеСпискаКлиент(Событие)
	Замер = НачатьЗамер(Событие);
	ОбновитьСодержимоеСписка(Событие);
	ЗакончитьЗамер(Замер);
КонецПроцедуры

&НаКлиенте
Функция НачатьЗамер(Событие)
	Если Не ПараметрыКлиента.ВыполнятьЗамеры Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтрокаПоиска) И (Событие = "СтрокаПоискаПриИзменении" Или Событие = "ВыполнитьПоиск") Тогда
		Имя = "СписокОтчетов.Поиск";
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	Комментарий = ПараметрыКлиента.ПрефиксЗамеров;
	
	Если ЗначениеЗаполнено(СтрокаПоиска) Тогда
		Комментарий = Комментарий
			+ "; " + НСтр("ru = 'Поиск:'") + " " + Строка(СтрокаПоиска)
			+ "; " + НСтр("ru = 'Включая подчиненные:'") + " " + Строка(ВключаяПодчиненные);
	Иначе
		Комментарий = Комментарий + "; " + НСтр("ru = 'Без поиска'");
	КонецЕсли;
	
	Замер = Новый Структура("МодульОценкаПроизводительностиКлиент, Идентификатор");
	Замер.МодульОценкаПроизводительностиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОценкаПроизводительностиКлиент");
	Замер.Идентификатор = Замер.МодульОценкаПроизводительностиКлиент.ЗамерВремени(Имя, Ложь, Ложь);
	Замер.МодульОценкаПроизводительностиКлиент.УстановитьКомментарийЗамера(Замер.Идентификатор, Комментарий);
	Возврат Замер;
КонецФункции

&НаКлиенте
Процедура ЗакончитьЗамер(Замер)
	Если Замер <> Неопределено Тогда
		Замер.МодульОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(Замер.Идентификатор);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти