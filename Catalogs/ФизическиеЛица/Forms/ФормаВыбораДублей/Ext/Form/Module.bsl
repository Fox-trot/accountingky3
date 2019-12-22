﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	СписокДублей.Параметры.УстановитьЗначениеПараметра("ИНН", СокрЛП(Параметры.ИНН));
	ЭтаФорма.Заголовок = НСтр("ru = 'Список дублей по ИНН'");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура СписокДублейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыПередачи = Новый Структура("Ключ", Элемент.ТекущиеДанные.Ссылка);
	ПараметрыПередачи.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	
	ОткрытьФорму("Справочник.ФизическиеЛица.ФормаОбъекта",
				  ПараметрыПередачи, 
				  Элемент,
				  ,
				  ,
				  ,
				  Новый ОписаниеОповещения("ОбработатьРедактированиеЭлемента", ЭтаФорма));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьРедактированиеЭлемента(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Элементы.СписокДублей.Обновить();
КонецПроцедуры

#КонецОбласти
