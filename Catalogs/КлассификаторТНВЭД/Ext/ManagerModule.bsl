﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ТаблицаКлассификатораТНВЭД() Экспорт
	
	ТаблицаПоказателей = Новый ТаблицаЗначений;
	
	Макет = Справочники.КлассификаторТНВЭД.ПолучитьМакет("КлассификаторТНВЭД");
	
	// В полученном макете содержатся значения всех списков используемых в отчете
	// ищем переданный
	Список = Макет.Области.Найти("Строки");
	
	Если Список.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Строки Тогда
		// заполнение дерева данными списка	
		ВерхОбласти = Список.Верх;
		НизОбласти = Список.Низ;
		
		НомерКолонки = 1;
		Область = Макет.Область(ВерхОбласти - 1, НомерКолонки);
		ИмяКолонки = Область.Текст;
		ДлинаКодаКлассификатора = 7;
		
		Пока ЗначениеЗаполнено(ИмяКолонки) Цикл
			
			Если ИмяКолонки = "Код" Тогда
				ТаблицаПоказателей.Колонки.Добавить("Код", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(12)));
			ИначеЕсли ИмяКолонки = "Наименование" Тогда
				ТаблицаПоказателей.Колонки.Добавить("Наименование",Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(255)));
			КонецЕсли;	
			
			НомерКолонки = НомерКолонки + 1;
			Область = Макет.Область(ВерхОбласти - 1, НомерКолонки);
			ИмяКолонки = Область.Текст;
			
		КонецЦикла;
		
		Для НомСтр = ВерхОбласти По НизОбласти Цикл
			// Отображаем только элементы
			
			Код = СокрП(Макет.Область(НомСтр, 1).Текст);
			Если СтрДлина(Код) = 2 Тогда
				Продолжить;
			КонецЕсли;
			СтрокаСписка = ТаблицаПоказателей.Добавить();
			
			Для Каждого Колонка Из ТаблицаПоказателей.Колонки Цикл
				
				ЗначениеКолонки = СокрП(Макет.Область(НомСтр, ТаблицаПоказателей.Колонки.Индекс(Колонка) + 1).Текст);
				СтрокаСписка[Колонка.Имя] = ЗначениеКолонки;
				
			КонецЦикла;
			
		КонецЦикла;
	КонецЕсли;
	
	ТаблицаПоказателей.Сортировать(ТаблицаПоказателей.Колонки[0].Имя + " Возр");
	
	Возврат ТаблицаПоказателей;
	
КонецФункции

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