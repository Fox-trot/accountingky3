﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Для каждого ОтветственноеЛицо Из Перечисления.ОтветственныеЛицаОрганизаций Цикл
		ВидыОтветственныхЛиц.Добавить(ОтветственноеЛицо);
	КонецЦикла;
	
	Если Параметры.Отбор.Свойство("Организация") Тогда
		ОтборОрганизация = Параметры.Отбор.Организация;
	Иначе
		ОтборОрганизация = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеНастройки("ОсновнаяОрганизация");
	КонецЕсли;
	
	РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Организация", ОтборОрганизация);

	Если Параметры.Отбор.Свойство("ОтветственноеЛицо") Тогда
		НайденноеЗначение = ВидыОтветственныхЛиц.НайтиПоЗначению(Параметры.Отбор.ОтветственноеЛицо);
		Если НЕ НайденноеЗначение = Неопределено Тогда
			Элементы.ВидыОтветственныхЛиц.ТекущаяСтрока	= НайденноеЗначение.ПолучитьИдентификатор();
		КонецЕсли;
		Параметры.Отбор.Удалить("ОтветственноеЛицо");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	РаботаСОтборамиКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Организация", ОтборОрганизация, ЗначениеЗаполнено(ОтборОрганизация));
КонецПроцедуры

&НаКлиенте
Процедура ВидыОтветственныхЛицПриАктивизацииСтроки(Элемент)
	РаботаСОтборамиКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "ОтветственноеЛицо", Элемент.ТекущиеДанные.Значение, Истина);
КонецПроцедуры

&НаКлиенте
Процедура СписокПослеУдаления(Элемент)
	Оповестить("ИзменениеОтветственныхЛиц", ОтборОрганизация);
	Оповестить("ИзмененСписокОтветственныхЛиц", ОтборОрганизация);
КонецПроцедуры

#КонецОбласти