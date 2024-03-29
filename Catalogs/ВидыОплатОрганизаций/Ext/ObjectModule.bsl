﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЭтоГруппа Тогда
		
		МассивНепроверяемыхРеквизитов = Новый Массив;
		
		Если ТипОплаты = Перечисления.ТипыОплат.Наличные Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Организация");
			МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
			МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
			МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаРасчетов");
		КонецЕсли;
		
		Если КомиссияБанка.Количество() > 1 Тогда
			ШаблонТекстаНезаполненноеПоле = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Колонка", "Заполнение", "%1", "%2", НСтр("ru = 'Комиссия банка'"));
			ШаблонТекстаНекорректноЗаполненноеПоле = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Колонка", "Корректность", "%1", "%2", НСтр("ru = 'Комиссия банка'"));
			ПредыдущаяСумма = 0;
			СоответствиеСумм = Новый Соответствие;
			Для каждого СтрокаКомиссия Из КомиссияБанка Цикл
				Если СтрокаКомиссия.НомерСтроки > 1 Тогда
					Если СтрокаКомиссия.СуммаОперацийОт = 0 Тогда
						ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							ШаблонТекстаНезаполненноеПоле, НСтр("ru = 'Сумма операций'"), СтрокаКомиссия.НомерСтроки);
						Поле = "КомиссияБанка[" + Формат((СтрокаКомиссия.НомерСтроки - 1), "ЧН=0; ЧГ=") + "].СуммаОперацийОт";
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
					ИначеЕсли СоответствиеСумм[СтрокаКомиссия.СуммаОперацийОт] <> Неопределено Тогда
						ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							ШаблонТекстаНекорректноЗаполненноеПоле, НСтр("ru = 'Сумма операций'"), СтрокаКомиссия.НомерСтроки,,
							НСтр("ru = 'Комиссия для такой суммы операций уже указана. Введите другое значение.'"));
						Поле = "КомиссияБанка[" + Формат((СтрокаКомиссия.НомерСтроки - 1), "ЧН=0; ЧГ=") + "].СуммаОперацийОт";
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
					ИначеЕсли ПредыдущаяСумма > СтрокаКомиссия.СуммаОперацийОт Тогда
						ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							ШаблонТекстаНекорректноЗаполненноеПоле, НСтр("ru = 'Сумма операций'"), СтрокаКомиссия.НомерСтроки,,
							НСтр("ru = 'Сумма операций должна быть больше чем в предыдущей строке. Введите другое значение.'"));
						Поле = "КомиссияБанка[" + Формат((СтрокаКомиссия.НомерСтроки - 1), "ЧН=0; ЧГ=") + "].СуммаОперацийОт";
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
					Иначе
						СоответствиеСумм.Вставить(СтрокаКомиссия.СуммаОперацийОт, СтрокаКомиссия.НомерСтроки);
					КонецЕсли;
				КонецЕсли;
				ПредыдущаяСумма = СтрокаКомиссия.СуммаОперацийОт;
			КонецЦикла;
		КонецЕсли;
		
		// Удаляем из проверяемых реквизитов все, по которым автоматическая проверка не нужна:
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнениеОбъектовБП.ЗаполнитьПоСтруктуре(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		СчетУчетаРасчетов = Справочники.ВидыОплатОрганизаций.СчетУчетаРасчетовПоУмолчанию(ТипОплаты);
		Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
