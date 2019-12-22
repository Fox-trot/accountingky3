﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПроверитьВозможностьИспользованияФормы(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТаблицуПереходов();
	УзелОбмена = Параметры.УзелОбмена;
	
	ИнициализироватьСвойстваФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьПорядковыйНомерПерехода(1);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	ИзменитьПорядковыйНомерПерехода(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаГотово(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиСобытийПереходов

////////////////////////////////////////////////////////////////////////////////
// Переопределяемая часть - Обработчики событий переходов.

&НаКлиенте
Функция Подключаемый_СтраницаОжидание_ДлительнаяОперация(Отказ, ПерейтиДалее)
	
	ПерейтиДалее = Ложь;
	
	ПриНачалеСохраненияНастройки();
	
КонецФункции

#КонецОбласти

#Область СохранениеНастройкиСинхронизации

&НаКлиенте
Процедура ПриНачалеСохраненияНастройки()
	
	ПродолжитьОжидание = Истина;
	ПриНачалеСохраненияНастройкиСинхронизацииНаСервере(ПродолжитьОжидание);
	
	Если ПродолжитьОжидание Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(
			ПараметрыОбработчикаОжиданияСохраненияНастроек);
			
		ПодключитьОбработчикОжидания("ПриОжиданииСохраненияНастройки",
			ПараметрыОбработчикаОжиданияСохраненияНастроек.ТекущийИнтервал, Истина);
	Иначе
		ПриЗавершенииСохраненияНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОжиданииСохраненияНастройки()
	
	ПродолжитьОжидание = Ложь;
	ПриОжиданииСохраненияНастройкиНаСервере(ПараметрыОбработчикаСохраненияНастроек, ПродолжитьОжидание);
	
	Если ПродолжитьОжидание Тогда
		ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжиданияСохраненияНастроек);
		
		ПодключитьОбработчикОжидания("ПриОжиданииСохраненияНастройки",
			ПараметрыОбработчикаОжиданияСохраненияНастроек.ТекущийИнтервал, Истина);
	Иначе
		ПриЗавершенииСохраненияНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииСохраненияНастройки()
	
	ПараметрыОбработчикаОжиданияСохраненияНастроек = Неопределено;
	
	Отказ = Ложь;
	СообщениеОбОшибке = "";
	ПриЗавершенииСохраненияНастройкиНаСервере(Отказ, СообщениеОбОшибке);
	
	Если Отказ Тогда
		ИзменитьПорядковыйНомерПерехода(-1);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке);
	Иначе
		ИзменитьПорядковыйНомерПерехода(+1);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриНачалеСохраненияНастройкиСинхронизацииНаСервере(ПродолжитьОжидание)
	
	НастройкиСинхронизации = Новый Структура;
	НастройкиСинхронизации.Вставить("УзелОбмена",       УзелОбмена);
	НастройкиСинхронизации.Вставить("ДанныеЗаполнения", Новый Структура);
	
	НастройкиСинхронизации.ДанныеЗаполнения.Вставить("ДатаНачалаВыгрузкиДокументов",      ДатаНачалаВыгрузкиДокументов);
		
	ПараметрыОбработчикаСохраненияНастроек = Неопределено;
	ОбменДаннымиСервер.ПриНачалеСохраненияНастроекСинхронизации(
		НастройкиСинхронизации, ПараметрыОбработчикаСохраненияНастроек, ПродолжитьОжидание);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриОжиданииСохраненияНастройкиНаСервере(ПараметрыОбработчика, ПродолжитьОжидание)
	
	ОбменДаннымиСервер.ПриОжиданииСохраненияНастроекСинхронизации(
		ПараметрыОбработчика, ПродолжитьОжидание);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗавершенииСохраненияНастройкиНаСервере(Отказ, СообщениеОбОшибке)
	
	СтатусЗавершения = Неопределено;
	ОбменДаннымиСервер.ПриЗавершенииСохраненияНастроекСинхронизации(
		ПараметрыОбработчикаСохраненияНастроек, СтатусЗавершения);
	ПараметрыОбработчикаСохраненияНастроек = Неопределено;
		
	Если СтатусЗавершения.Отказ Тогда
		Отказ = Истина;
		СообщениеОбОшибке = СтатусЗавершения.СообщениеОбОшибке;
		Возврат;
	Иначе
		
		Если Не СтатусЗавершения.Результат.НастройкиСохранены Тогда
			Отказ = Истина;
			СообщениеОбОшибке = СтатусЗавершения.Результат.СообщениеОбОшибке;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ИнициализацияФормыПриСоздании

&НаСервере
Процедура ПроверитьВозможностьИспользованияФормы(Отказ = Ложь)
	
	// Обязательная должны быть переданы параметры помощника настройки синхронизации.
	Если Не Параметры.Свойство("УзелОбмена")
		Или Не ЗначениеЗаполнено(Параметры.УзелОбмена) Тогда
		ТекстСообщения = НСтр("ru = 'Форма не предназначена для непосредственного использования.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьСвойстваФормы()
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Настройка синхронизации данных с ""%1""'"),
		УзелОбмена);
	
КонецПроцедуры

#КонецОбласти

#Область СценарииРаботыПомощника

&НаСервере
Функция ДобавитьСтрокуТаблицыПереходов(ИмяОсновнойСтраницы, ИмяСтраницыНавигации, ИмяСтраницыДекорации = "")
	
	СтрокаПереходов = ТаблицаПереходов.Добавить();
	СтрокаПереходов.ПорядковыйНомерПерехода = ТаблицаПереходов.Количество();
	СтрокаПереходов.ИмяОсновнойСтраницы = ИмяОсновнойСтраницы;
	СтрокаПереходов.ИмяСтраницыНавигации = ИмяСтраницыНавигации;
	СтрокаПереходов.ИмяСтраницыДекорации = ИмяСтраницыДекорации;
	
	Возврат СтрокаПереходов;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуПереходов()
	
	ТаблицаПереходов.Очистить();
	
	НовыйПереход = ДобавитьСтрокуТаблицыПереходов("СтраницаОтборПоДате", "СтраницаНавигацияНачало");
	НовыйПереход = ДобавитьСтрокуТаблицыПереходов("СтраницаОжидание", "СтраницаНавигацияПродолжение");
	
	НовыйПереход.ДлительнаяОперация = Истина;
	НовыйПереход.ИмяОбработчикаДлительнойОперации = "СтраницаОжидание_ДлительнаяОперация";
	
	НовыйПереход = ДобавитьСтрокуТаблицыПереходов("СтраницаЗавершение", "СтраницаНавигацияОкончание");
	
КонецПроцедуры

#КонецОбласти

#Область ДополнительныеОбработчикиПереходов

////////////////////////////////////////////////////////////////////////////////
// Поставляемая часть

&НаКлиенте
Процедура ИзменитьПорядковыйНомерПерехода(Итератор)
	
	ОчиститьСообщения();
	
	УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + Итератор);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПорядковыйНомерПерехода(Знач Значение)
	
	ЭтоПереходДалее = (Значение > ПорядковыйНомерПерехода);
	
	ПорядковыйНомерПерехода = Значение;
	
	Если ПорядковыйНомерПерехода < 0 Тогда
		
		ПорядковыйНомерПерехода = 0;
		
	КонецЕсли;
	
	ПорядковыйНомерПереходаПриИзменении(ЭтоПереходДалее);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядковыйНомерПереходаПриИзменении(Знач ЭтоПереходДалее)
	
	// Выполняем обработчики событий перехода.
	ВыполнитьОбработчикиСобытийПерехода(ЭтоПереходДалее);
	
	// Устанавливаем отображение страниц.
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Элементы.ПанельОсновная.ТекущаяСтраница  = Элементы[СтрокаПереходаТекущая.ИмяОсновнойСтраницы];
	Элементы.ПанельНавигации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыНавигации];
	
	Элементы.ПанельНавигации.ТекущаяСтраница.Доступность = Не (ЭтоПереходДалее И СтрокаПереходаТекущая.ДлительнаяОперация);
	
	// Устанавливаем текущую кнопку по умолчанию.
	КнопкаДалее = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаДалее");
	
	Если КнопкаДалее <> Неопределено Тогда
		
		КнопкаДалее.КнопкаПоУмолчанию = Истина;
		
	Иначе
		
		КнопкаГотово = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаГотово");
		
		Если КнопкаГотово <> Неопределено Тогда
			
			КнопкаГотово.КнопкаПоУмолчанию = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоПереходДалее И СтрокаПереходаТекущая.ДлительнаяОперация Тогда
		
		ПодключитьОбработчикОжидания("ВыполнитьОбработчикДлительнойОперации", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикиСобытийПерехода(Знач ЭтоПереходДалее)
	
	// Обработчики событий переходов.
	Если ЭтоПереходДалее Тогда
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода - 1));
		
		Если СтрокиПерехода.Количество() > 0 Тогда
			
			СтрокаПерехода = СтрокиПерехода[0];
			
			// Обработчик ПриПереходеДалее.
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеДалее)
				И Не СтрокаПерехода.ДлительнаяОперация Тогда
				
				ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеДалее);
				
				Отказ = Ложь;
				
				Результат = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					
					ПорядковыйНомерПерехода = ПорядковыйНомерПерехода - 1;
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода + 1));
		
		Если СтрокиПерехода.Количество() > 0 Тогда
			
			СтрокаПерехода = СтрокиПерехода[0];
			
			// Обработчик ПриПереходеНазад.
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеНазад)
				И Не СтрокаПерехода.ДлительнаяОперация Тогда
				
				ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеНазад);
				
				Отказ = Ложь;
				
				Результат = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					
					ПорядковыйНомерПерехода = ПорядковыйНомерПерехода + 1;
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Если СтрокаПереходаТекущая.ДлительнаяОперация И Не ЭтоПереходДалее Тогда
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
		Возврат;
	КонецЕсли;
	
	// обработчик ПриОткрытии
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПропуститьСтраницу, ЭтоПереходДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии);
		
		Отказ = Ложь;
		ПропуститьСтраницу = Ложь;
		
		Результат = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			ПорядковыйНомерПерехода = ПорядковыйНомерПерехода - 1;
			Возврат;
			
		ИначеЕсли ПропуститьСтраницу Тогда
			
			Если ЭтоПереходДалее Тогда
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				Возврат;
				
			Иначе
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикДлительнойОперации()
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	// Обработчик ОбработкаДлительнойОперации.
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПерейтиДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации);
		
		Отказ = Ложь;
		ПерейтиДалее = Истина;
		
		Результат = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			ПорядковыйНомерПерехода = ПорядковыйНомерПерехода - 1;
			Возврат;
			
		ИначеЕсли ПерейтиДалее Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
			Возврат;
			
		КонецЕсли;
		
	Иначе
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьКнопкуФормыПоИмениКоманды(ЭлементФормы, ИмяКоманды)
	
	Для Каждого Элемент Из ЭлементФормы.ПодчиненныеЭлементы Цикл
		
		Если ТипЗнч(Элемент) = Тип("ГруппаФормы") Тогда
			
			ЭлементФормыПоИмениКоманды = ПолучитьКнопкуФормыПоИмениКоманды(Элемент, ИмяКоманды);
			
			Если ЭлементФормыПоИмениКоманды <> Неопределено Тогда
				
				Возврат ЭлементФормыПоИмениКоманды;
				
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("КнопкаФормы")
			И СтрНайти(Элемент.ИмяКоманды, ИмяКоманды) > 0 Тогда
			
			Возврат Элемент;
			
		Иначе
			
			Продолжить;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти