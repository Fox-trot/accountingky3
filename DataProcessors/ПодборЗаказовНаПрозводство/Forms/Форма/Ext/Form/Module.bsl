﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	ЗаполнитьЗначенияСвойств(Объект, Параметры);
	
	Для Каждого ПодобраннаяСтрокаДокумента Из Параметры.ТабличнаяЧастьГП Цикл		
		СтрокаТабличнойЧасти = Объект.ПодобранныеСтрокиИзДокумента.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ПодобраннаяСтрокаДокумента);		
	КонецЦикла;
	
	ЦветСтиляНедоступныеДанные = ОбщегоНазначенияВызовСервера.ЦветСтиля("НедоступныеДанныеЦвет");
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьПараметрыДинамическихСписков(Истина);
	
	ОтредактироватьУсловноеОформление("ЗаполнитьПоСтрокамИзДокумента");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура вызывается при нажатии кнопки "ПеренестиВДокумент". 
//
&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	Закрыть(ЗаписатьПодборВХранилище());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьПараметрыДинамическихСписков(ПервоначальноеЗаполнение = Ложь)

	Если ПервоначальноеЗаполнение Тогда
		СписокКонтрагентов.Параметры.УстановитьЗначениеПараметра("Период", Объект.Период);
		СписокКонтрагентов.Параметры.УстановитьЗначениеПараметра("Организация", Объект.Организация);
		СписокКонтрагентов.Параметры.УстановитьЗначениеПараметра("Регистратор", Объект.Регистратор);
		СписокКонтрагентов.Параметры.УстановитьЗначениеПараметра("Проведен", Объект.Проведен);
		
		СписокЗаказов.Параметры.УстановитьЗначениеПараметра("Период", Объект.Период);
		СписокЗаказов.Параметры.УстановитьЗначениеПараметра("Организация", Объект.Организация);
		СписокЗаказов.Параметры.УстановитьЗначениеПараметра("Регистратор", Объект.Регистратор);
		СписокЗаказов.Параметры.УстановитьЗначениеПараметра("Проведен", Объект.Проведен);
			
		СписокПродукции.Параметры.УстановитьЗначениеПараметра("Период", Объект.Период);
		СписокПродукции.Параметры.УстановитьЗначениеПараметра("Организация", Объект.Организация);
		СписокПродукции.Параметры.УстановитьЗначениеПараметра("Регистратор", Объект.Регистратор);
		СписокПродукции.Параметры.УстановитьЗначениеПараметра("Проведен", Объект.Проведен);
		                                                                                     
		СписокВидовРабот.Параметры.УстановитьЗначениеПараметра("Период", Объект.Период);
		СписокВидовРабот.Параметры.УстановитьЗначениеПараметра("Организация", Объект.Организация);
		СписокВидовРабот.Параметры.УстановитьЗначениеПараметра("Регистратор", Объект.Регистратор);
		СписокВидовРабот.Параметры.УстановитьЗначениеПараметра("Проведен", Объект.Проведен);
	КонецЕсли;
	
	СписокЗаказов.Параметры.УстановитьЗначениеПараметра("УстановитьОтборПоКонтрагенту", Объект.УстановитьОтборПоКонтрагенту);
	СписокЗаказов.Параметры.УстановитьЗначениеПараметра("Контрагент", Объект.ТекущийКонтрагент);
	СписокПродукции.Параметры.УстановитьЗначениеПараметра("Заказ", Объект.ТекущийЗаказ);
	СписокВидовРабот.Параметры.УстановитьЗначениеПараметра("Заказ", Объект.ТекущийЗаказ);
	СписокВидовРабот.Параметры.УстановитьЗначениеПараметра("Номенклатура", Объект.ТекущаяПродукция);	
КонецПроцедуры

&НаСервере
Процедура ОтредактироватьУсловноеОформление(НаименованиеДействия, ВидРабот = Неопределено)

	// Оформление подобранных товаров.
	ЭлементыУсловногоОформленияСписка = СписокВидовРабот.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы;
	
	Если НаименованиеДействия = "ЗаполнитьПоСтрокамИзДокумента" Тогда	
		
		// Подобранные в документе
		Для Каждого СтрокаТабличнойЧасти Из Объект.ПодобранныеСтрокиИзДокумента Цикл 
			ЭлементУсловногоОформления = ЭлементыУсловногоОформленияСписка.Добавить();
			ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
			ЭлементУсловногоОформления.ИдентификаторПользовательскойНастройки = "Предустановленный";
			ЭлементУсловногоОформления.Представление = "Уже подобран";  
			
			// Цвет
			ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
			ЭлементЦветаОформления.Значение = ЦветСтиляНедоступныеДанные;
			ЭлементЦветаОформления.Использование = Истина;

			// Группа
			ГруппаЭлементовОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
			ГруппаЭлементовОтбораДанных.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
			ГруппаЭлементовОтбораДанных.Использование = Истина;
			
			// Отбор по заказу		
			ЭлементОтбораДанных = ГруппаЭлементовОтбораДанных.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Заказ");
			ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
			ЭлементОтбораДанных.ПравоеЗначение = СтрокаТабличнойЧасти.Заказ;
			ЭлементОтбораДанных.Использование  = Истина;
			
			// Отбор по номенклатуре		
			ЭлементОтбораДанных = ГруппаЭлементовОтбораДанных.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Номенклатура");
			ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
			ЭлементОтбораДанных.ПравоеЗначение = СтрокаТабличнойЧасти.Номенклатура;
			ЭлементОтбораДанных.Использование  = Истина;
			
			// Отбор по виду работы		
			ЭлементОтбораДанных = ГруппаЭлементовОтбораДанных.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ВидРабот");
			ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
			ЭлементОтбораДанных.ПравоеЗначение = СтрокаТабличнойЧасти.ВидРаботы;
			ЭлементОтбораДанных.Использование  = Истина;
		КонецЦикла;		
		
	ИначеЕсли НаименованиеДействия = "ЗаполнитьПоПодобраннымСтрокам" Тогда	
		
		МассивСтрокНаУдаление = Новый Массив();
		
		// Удаление оформления по строкам ТЧ "ПодобранныеСтроки"
		Для Каждого ЭлементУсловногоОформления Из ЭлементыУсловногоОформленияСписка Цикл			
			Если ЭлементУсловногоОформления.ИдентификаторПользовательскойНастройки = "Переменный" Тогда
				МассивСтрокНаУдаление.Добавить(ЭлементУсловногоОформления);
			КонецЕсли;			
		КонецЦикла;
		
		Для Каждого СтрокаМассива Из МассивСтрокНаУдаление Цикл
			ЭлементыУсловногоОформленияСписка.Удалить(СтрокаМассива);	
		КонецЦикла;
		
		// Подобранные в обработке
		Для Каждого СтрокаТабличнойЧасти Из Объект.ПодобранныеСтроки Цикл 
			ЭлементУсловногоОформления = ЭлементыУсловногоОформленияСписка.Добавить();
			ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
			ЭлементУсловногоОформления.ИдентификаторПользовательскойНастройки = "Переменный";
			ЭлементУсловногоОформления.Представление = "Уже подобран";  
			
			// Цвет
			ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
			ЭлементЦветаОформления.Значение = ЦветСтиляНедоступныеДанные;
			ЭлементЦветаОформления.Использование = Истина;

			// Группа
			ГруппаЭлементовОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
			ГруппаЭлементовОтбораДанных.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
			ГруппаЭлементовОтбораДанных.Использование = Истина;
			
			// Отбор по заказу		
			ЭлементОтбораДанных = ГруппаЭлементовОтбораДанных.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Заказ");
			ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
			ЭлементОтбораДанных.ПравоеЗначение = СтрокаТабличнойЧасти.Заказ;
			ЭлементОтбораДанных.Использование  = Истина;
			
			// Отбор по номенклатуре		
			ЭлементОтбораДанных = ГруппаЭлементовОтбораДанных.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Номенклатура");
			ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
			ЭлементОтбораДанных.ПравоеЗначение = СтрокаТабличнойЧасти.Номенклатура;
			ЭлементОтбораДанных.Использование  = Истина;
			
			// Отбор по виду работы		
			ЭлементОтбораДанных = ГруппаЭлементовОтбораДанных.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ВидРабот");
			ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
			ЭлементОтбораДанных.ПравоеЗначение = СтрокаТабличнойЧасти.ВидРаботы;
			ЭлементОтбораДанных.Использование  = Истина;
		КонецЦикла;
		
	ИначеЕсли НаименованиеДействия = "ЗаполнитьПоПодбираемойСтроке" Тогда
		
		ЭлементУсловногоОформления = ЭлементыУсловногоОформленияСписка.Добавить();
		ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементУсловногоОформления.ИдентификаторПользовательскойНастройки = "Переменный";
		ЭлементУсловногоОформления.Представление = "Уже подобран";  
		
		// Цвет
		ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
		ЭлементЦветаОформления.Значение = ЦветСтиляНедоступныеДанные;
		ЭлементЦветаОформления.Использование = Истина;

		// Группа
		ГруппаЭлементовОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаЭлементовОтбораДанных.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
		ГруппаЭлементовОтбораДанных.Использование = Истина;
		
		// Отбор по заказу		
		ЭлементОтбораДанных = ГруппаЭлементовОтбораДанных.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Заказ");
		ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораДанных.ПравоеЗначение = Объект.ТекущийЗаказ;
		ЭлементОтбораДанных.Использование  = Истина;
		
		// Отбор по номенклатуре		
		ЭлементОтбораДанных = ГруппаЭлементовОтбораДанных.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Номенклатура");
		ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораДанных.ПравоеЗначение = Объект.ТекущаяПродукция;
		ЭлементОтбораДанных.Использование  = Истина;
		
		// Отбор по виду работы		
		ЭлементОтбораДанных = ГруппаЭлементовОтбораДанных.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ВидРабот");
		ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораДанных.ПравоеЗначение = ВидРабот;		
	КонецЕсли;
КонецПроцедуры

// Процедура записывает подобранные документы в хранилище.
//
// Возвращаемое значение:
//  Структура - адрес в хранилище и идентификатор формы владельца.
//
&НаСервере
Функция ЗаписатьПодборВХранилище()
	ТЗВозврата = Объект.ПодобранныеСтроки.Выгрузить();

	АдресКорзиныВХранилище = ПоместитьВоВременноеХранилище(ТЗВозврата, Объект.УникальныйИдентификаторФормыВладельца);
	Возврат Новый Структура("АдресКорзиныВХранилище, УникальныйИдентификаторФормыВладельца", АдресКорзиныВХранилище, Объект.УникальныйИдентификаторФормыВладельца);
	
КонецФункции

&НаКлиенте
Процедура СписокЗаказовПриАктивизацииСтроки(Элемент)
	
	Если НЕ Элемент.ТекущиеДанные = Неопределено Тогда	
		Объект.ТекущийЗаказ = Элемент.ТекущиеДанные.Заказ;
		Объект.ЗаказПолуфабрикатов = Элемент.ТекущиеДанные.Полуфабрикаты;
		Если НЕ Объект.УстановитьОтборПоКонтрагенту Тогда
			Объект.ТекущийКонтрагент = Элемент.ТекущиеДанные.Контрагент;
		КонецЕсли;
		УстановитьПараметрыДинамическихСписков();
		
		ОбновитьСписокВидовРабот();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокВидовРабот()
	ТекущиеДанныеПродукции = Элементы.СписокПродукции.ТекущиеДанные;
	Если ТекущиеДанныеПродукции <> Неопределено Тогда
		Объект.ТекущаяПродукция = ТекущиеДанныеПродукции.Номенклатура;
		Объект.ТекущееКоличество = ТекущиеДанныеПродукции.Количество;
		Объект.ТекущийСклад = ТекущиеДанныеПродукции.Склад;
		Объект.ТекущаяСпецификация = ТекущиеДанныеПродукции.Спецификация;
	КонецЕсли;	
	УстановитьПараметрыДинамическихСписков();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокПродукции()
	ТекущиеДанныеЗаказов = Элементы.СписокЗаказов.ТекущиеДанные;
	Если ТекущиеДанныеЗаказов <> Неопределено Тогда
		Объект.ТекущийЗаказ = ТекущиеДанныеЗаказов.Заказ;
		Объект.ЗаказПолуфабрикатов = ТекущиеДанныеЗаказов.Полуфабрикаты;
		Если Объект.УстановитьОтборПоКонтрагенту Тогда
			Объект.ТекущийКонтрагент = ТекущиеДанныеЗаказов.Контрагент;
		КонецЕсли;
	КонецЕсли;	
	УстановитьПараметрыДинамическихСписков();
КонецПроцедуры

&НаКлиенте
Процедура СписокПродукцииПриАктивизацииСтроки(Элемент)
	
	Если НЕ Элемент.ТекущиеДанные = Неопределено Тогда
		Объект.ТекущаяПродукция = Элемент.ТекущиеДанные.Номенклатура;
		Объект.ТекущееКоличество = Элемент.ТекущиеДанные.Количество;
		Объект.ТекущаяСпецификация = Элемент.ТекущиеДанные.Спецификация;
		УстановитьПараметрыДинамическихСписков();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокКонтрагентовПриАктивизацииСтроки(Элемент)
	Если Объект.УстановитьОтборПоКонтрагенту Тогда
		Объект.ТекущийКонтрагент = Элемент.ТекущиеДанные.Контрагент;
	КонецЕсли;
	УстановитьПараметрыДинамическихСписков();
	
	ОбновитьСписокПродукции();
	ОбновитьСписокВидовРабот();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоКонтрагентуПриИзменении(Элемент)
	Если Объект.УстановитьОтборПоКонтрагенту Тогда
		Объект.ТекущийКонтрагент = Элементы.СписокКонтрагентов.ТекущиеДанные.Контрагент;
	КонецЕсли;
	УстановитьПараметрыДинамическихСписков();
	
	ОбновитьСписокПродукции();
	ОбновитьСписокВидовРабот();
КонецПроцедуры

&НаКлиенте
Процедура СписокВидовРаботВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ЗаполнитьПоПодобраннойСтроке(Элемент.ТекущиеДанные.ВидРабот);
КонецПроцедуры

&НаКлиенте
Процедура СписокВидовРаботОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	ЗаполнитьПоПодобраннойСтроке(Элемент.ТекущиеДанные.ВидРабот);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПодобраннойСтроке(ВидРаботы)
	
	Структура = Новый Структура();
	Структура.Вставить("Заказ", Объект.ТекущийЗаказ);
	Структура.Вставить("Номенклатура", Объект.ТекущаяПродукция);
	Структура.Вставить("ВидРаботы", ВидРаботы);
	
	Если Объект.ПодобранныеСтроки.НайтиСтроки(Структура).Количество() <> 0
		ИЛИ Объект.ПодобранныеСтрокиИзДокумента.НайтиСтроки(Структура).Количество() <> 0 Тогда
		Возврат;
	Иначе
		СтрокаТабличнойЧасти = Объект.ПодобранныеСтроки.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, Структура);
		СтрокаТабличнойЧасти.Контрагент = Объект.ТекущийКонтрагент;
		СтрокаТабличнойЧасти.Количество = Объект.ТекущееКоличество;
		СтрокаТабличнойЧасти.Склад = Объект.ТекущийСклад;
		СтрокаТабличнойЧасти.Полуфабрикаты = Объект.ЗаказПолуфабрикатов;
		СтрокаТабличнойЧасти.Спецификация = Объект.ТекущаяСпецификация;
		
		ОтредактироватьУсловноеОформление("ЗаполнитьПоПодбираемойСтроке", ВидРаботы);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПодобранныеСтрокиПослеУдаления(Элемент)
	ОтредактироватьУсловноеОформление("ЗаполнитьПоПодобраннымСтрокам");
КонецПроцедуры

#КонецОбласти
