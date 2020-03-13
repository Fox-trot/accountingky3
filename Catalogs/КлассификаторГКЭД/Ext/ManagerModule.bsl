﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает описание блокируемых реквизитов.
//
// Возвращаемое значение:
//  Массив - содержит строки в формате ИмяРеквизита[;ИмяЭлементаФормы,...]
//           где ИмяРеквизита - имя реквизита объекта, ИмяЭлементаФормы - имя элемента формы,
//           связанного с реквизитом.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив;
	
	БлокируемыеРеквизиты.Добавить("Код");
	БлокируемыеРеквизиты.Добавить("Наименование");
	БлокируемыеРеквизиты.Добавить("НаименованиеПолное");
	БлокируемыеРеквизиты.Добавить("Сырьевой");
	БлокируемыеРеквизиты.Добавить("ЕдиницаИзмерения");
	БлокируемыеРеквизиты.Добавить("ДатаНачалаДействия");
	БлокируемыеРеквизиты.Добавить("ДатаОкончанияДействия");
	
	Возврат БлокируемыеРеквизиты;
	
КонецФункции 

#КонецОбласти

#КонецЕсли