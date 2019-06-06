﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Дата = ТекущаяДатаСеанса();
	
	СозданиеНового = Объект.Ссылка.Пустая();
	РедактированиеПериодическихСведений.ПрочитатьЗаписьДляРедактированияВФорме(ЭтаФорма, "СтавкиНалоговЗаработнойПлаты", Объект.Ссылка);
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(ЭтаФорма, "СтавкиНалоговЗаработнойПлаты", Объект.Ссылка);
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриЗаписиНаСервере.
//
&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ДополнительныеСвойства = Новый Структура;
	
	Если СозданиеНового Тогда
		ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
	КонецЕсли;
	
	РедактированиеПериодическихСведений.ЗаписатьНаборЗаписей(
		ЭтаФорма,
		"СтавкиНалоговЗаработнойПлаты",
		ТекущийОбъект.Ссылка,
		,
		ДополнительныеСвойства);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтавкиНалоговЗаработнойПлатыНаборЗаписейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда 
		// получаем текущую строку
		СтрокаТабличнойЧасти = Элемент.ТекущиеДанные;
		
		// не удалось получить- возвращаемся
		Если СтрокаТабличнойЧасти = Неопределено Тогда 
			Возврат;
		КонецЕсли;
		
		СтрокаТабличнойЧасти.Период = НачалоМесяца(Дата);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура КатегорияПриИзменении(Элемент)
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	Если Объект.Категория = Справочники.КатегорииСотрудников.Арендодатели Тогда 
		Элементы.СтавкиНалоговЗаработнойПлатыНаборЗаписейСтавкаМСР.Видимость = Истина;
	Иначе 
		Элементы.СтавкиНалоговЗаработнойПлатыНаборЗаписейСтавкаМСР.Видимость = Ложь;
	КонецЕсли;	
КонецПроцедуры 

#КонецОбласти

