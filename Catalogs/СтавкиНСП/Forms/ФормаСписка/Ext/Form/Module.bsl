﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущаяДата = НачалоДня(ТекущаяДатаСеанса());
	ОсновнаяОрганизация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	Список.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ТекущаяДата", ТекущаяДата);
	Список.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ОсновнаяОрганизация", ОсновнаяОрганизация);
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененаСтавкаНСП" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицФормы

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	Перем ТекущаяДата, ОсновнаяОрганизация;
	
	Если Не Настройки.ДополнительныеСвойства.Свойство("ТекущаяДата", ТекущаяДата)
		Или Не Настройки.ДополнительныеСвойства.Свойство("ОсновнаяОрганизация", ОсновнаяОрганизация) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СтавкиНСП.СтавкаНСП КАК СтавкаНСП,
		|	СтавкиНСП.Ставка КАК Ставка
		|ИЗ
		|	РегистрСведений.СтавкиНСП.СрезПоследних(
		|			&КонецПериода,
		|			Организация = &Организация
		|				И СтавкаНСП В (&Ставки)) КАК СтавкиНСП";
	Запрос.УстановитьПараметр("Ставки", Строки.ПолучитьКлючи());
	Запрос.УстановитьПараметр("КонецПериода", ТекущаяДата);
	Запрос.УстановитьПараметр("Организация", ОсновнаяОрганизация);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаСписка = Строки[Выборка.СтавкаНСП];
		СтрокаСписка.Данные["Ставка"] = Выборка.Ставка;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ПоказатьПредупреждение(,НСтр("ru = 'Добавление новых элементов не предусмотрено.'"));
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти