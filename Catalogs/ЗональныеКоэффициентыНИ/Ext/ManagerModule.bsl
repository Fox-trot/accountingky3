﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Процедура - Заполнить по умолчанию
// Выполняет первоночальное заполнение
Процедура ЗаполнитьПоУмолчанию() Экспорт 
	СправочникСсылка = Справочники.ЗональныеКоэффициентыНИ.ОсновнаяЗона;
	СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
	СправочникОбъект.Коэффициент = 1;       

	БухгалтерскийУчетКлиентСервер.ЗаписатьСправочникОбъект(СправочникОбъект);
		
	ПериодНабораЗаписей = НачалоГода(ТекущаяДатаСеанса());
	
	НаборЗаписей = РегистрыСведений.КоэфицентыНалогаНаИмущество.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Период.Установить(ПериодНабораЗаписей);
	НаборЗаписей.Отбор.Классификация.Установить(СправочникСсылка);
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить(); 
	
	ЗаписьНабораЗаписей = НаборЗаписей.Добавить();
	ЗаписьНабораЗаписей.Период = КонецГода(ПериодНабораЗаписей);
	ЗаписьНабораЗаписей.Классификация = СправочникСсылка;
	ЗаписьНабораЗаписей.Коэфициент = 1;
		
	Попытка
		НаборЗаписей.Записать(); 	
	Исключение
	КонецПопытки; 
КонецПроцедуры // ЗаполнитьПоУмолчанию()	

#КонецОбласти
	
#КонецЕсли

