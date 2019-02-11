﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Для Каждого ФайлСсылка Из Параметры.МассивФайлов Цикл
		НовыйЭлемент = ВыбранныеФайлы.Добавить();
		НовыйЭлемент.Ссылка = ФайлСсылка;
		НовыйЭлемент.ИндексКартинки = ФайлСсылка.ИндексКартинки;
	КонецЦикла;
	
	ВозможностьСоздаватьВерсииФайлов = Параметры.ВозможностьСоздаватьВерсииФайлов;
	Редактирует = Параметры.Редактирует;
	
	Элементы.ХранитьВерсии.Видимость = ВозможностьСоздаватьВерсииФайлов;
	
	ПерсональныеНастройкиРаботыСФайлами = РаботаСФайлами.НастройкиРаботыСФайлами();
	Элементы.УдалитьФайлыИзОсновногоКаталога.Видимость = ПерсональныеНастройкиРаботыСФайлами.ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов;
	УдалитьФайлыИзОсновногоКаталога = ПерсональныеНастройкиРаботыСФайлами.УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ХранитьВерсии = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВыбранныеФайлы

&НаКлиенте
Процедура ВыбранныеФайлыПередНачаломДобавления(Элемент, Отказ, Копирование)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакончитьРедактирование()
	
	МассивФайлов = Новый Массив;
	Для Каждого ЭлементСписка Из ВыбранныеФайлы Цикл
		МассивФайлов.Добавить(ЭлементСписка.Ссылка);
	КонецЦикла;
	
	ПараметрыОбновленияФайлов = Новый Структура;
	ПараметрыОбновленияФайлов.Вставить("МассивФайлов",                     МассивФайлов);
	ПараметрыОбновленияФайлов.Вставить("ВозможностьСоздаватьВерсииФайлов", ВозможностьСоздаватьВерсииФайлов);
	ПараметрыОбновленияФайлов.Вставить("ХранитьВерсии", ХранитьВерсии);
	Если Не ВозможностьСоздаватьВерсииФайлов Тогда
		ПараметрыОбновленияФайлов.Вставить("СоздатьНовуюВерсию", Ложь);
	КонецЕсли;
	ПараметрыОбновленияФайлов.Вставить("ФайлРедактируетТекущийПользователь", Истина);
	ПараметрыОбновленияФайлов.Вставить("ОбработчикРезультата",               Неопределено);
	ПараметрыОбновленияФайлов.Вставить("ИдентификаторФормы",                 УникальныйИдентификатор);
	ПараметрыОбновленияФайлов.Вставить("Редактирует",                        Редактирует);
	ПараметрыОбновленияФайлов.Вставить("КомментарийКВерсии",                 Комментарий);
	ПараметрыОбновленияФайлов.Вставить("ПоказыватьОповещение",               Ложь);
	ПараметрыОбновленияФайлов.Вставить("УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования2", УдалитьФайлыИзОсновногоКаталога);
	
	РаботаСФайламиСлужебныйКлиент.ЗакончитьРедактированиеПоСсылкамСОповещением(ПараметрыОбновленияФайлов);
	Закрыть();
КонецПроцедуры

#КонецОбласти